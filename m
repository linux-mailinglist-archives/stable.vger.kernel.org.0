Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35A333051E
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 00:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhCGXAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 18:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbhCGW7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 17:59:51 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69098C06174A;
        Sun,  7 Mar 2021 14:59:51 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id r5so3789647qvv.9;
        Sun, 07 Mar 2021 14:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=tz+Rio/qaBic+aovNFslXXjVD5rlN4szJOCvAjzCYNo=;
        b=LAip6MWhqrpHv6FbsHmbe9TeCsbS9XsE3DAY9h4aPKjPZkHGz9NsEUjwmOjlmmjo0W
         mYnepG/G9afo9XxR2mmmiDCQuTFhLBBMDSo0b8dXjNqHr34mCuIDCKcv//LQJpGp3voZ
         Qd3Kqu+F1/wTcB0zbSitohqWB3qsVQGxGslQX0t97h+P4fcR8JDcGnuMMnphFKPMDnC6
         JoQITKylnqQ1n+4NPrv3cPv955idAnox8kQHaWuI+msdAXQflbW476bzUFvTHa6vwGhl
         x5ZXAfPtxM0waZJrXMx4LJadT6eCILg0iC39VrM6eg5MaarLZJ9VPIrCF0YwRgaDGXb+
         qrmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=tz+Rio/qaBic+aovNFslXXjVD5rlN4szJOCvAjzCYNo=;
        b=Mh58L2jG+1lhtuc0ax71X/SYq079hxmxVFa9xBaRTaZFWFLSnrPYaYUmGb/bH3il3h
         QuaygaDrrlOmJHcfk4h3SnfBHkHHJC6g58CVy8HU1YZyfrNNGtyN08Z3Xds2f0yVM1Yt
         Y7eLBD4UEYvaFQ3tsBgdJQCBwYr6SQdF5Ha1ajxLf2zLzRP24q1ykojkEKvXiA8zgk0l
         gmoDn32G8/4lmYxNSqvy4nFIfvvrMRHdfqqEOGszUqSnbxc39zr/aRzoUwj4cJ1FAD8p
         iFbdml64HOqZa99Zl+F0ZvsLqXwEF6dtmUIzEjVQgmRz7zGBkaV/OUprhIw3mkCfszc5
         U5Og==
X-Gm-Message-State: AOAM5309kWJzTyawy2gDQNZzLhXd+A9QiD/yoaBjUJZYLluYZe9wv2CQ
        BVaHOfbIO1Ke1Wqz+o4b2W0=
X-Google-Smtp-Source: ABdhPJzCqKz4z+SnhCp7URvSEg72/QYhB65laBYJwIv/RefdITneNey+x+JC9WRIjcsSmL4jADNwCQ==
X-Received: by 2002:a0c:c583:: with SMTP id a3mr18331302qvj.15.1615157990018;
        Sun, 07 Mar 2021 14:59:50 -0800 (PST)
Received: from OpenSuse ([156.146.37.209])
        by smtp.gmail.com with ESMTPSA id d2sm6560241qkk.42.2021.03.07.14.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 14:59:48 -0800 (PST)
Date:   Mon, 8 Mar 2021 04:29:41 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Ronald Warsow <rwarsow@gmx.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: stable kernel checksumming fails
Message-ID: <YEVa3dLvugd4+9Cv@OpenSuse>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Ronald Warsow <rwarsow@gmx.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <d58ab27a-78ad-1119-79ac-2a1fbcd3527a@gmx.de>
 <YETm+6sQqek6kY/A@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i3HbxQlc7lFrG8j3"
Content-Disposition: inline
In-Reply-To: <YETm+6sQqek6kY/A@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--i3HbxQlc7lFrG8j3
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 15:45 Sun 07 Mar 2021, Greg KH wrote:
>On Sun, Mar 07, 2021 at 03:10:49PM +0100, Ronald Warsow wrote:
>> hello
>>
>> getting stable kernels with this script:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/mricon/korg-helpers.git/tree/get-verified-tarball
>>
>>
>> fails since the last 2 (?) stable releases with (last lines):
>>
>> ...
>>
>> + /usr/bin/curl -L -o
>> /home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted/linux-5.11.4.tar.xz
>> https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.11.4.tar.xz
>>   % Total    % Received % Xferd  Average Speed   Time    Time     Time
>> Current
>>                                  Dload  Upload   Total   Spent    Left
>> Speed
>> 100  112M  100  112M    0     0  5757k      0  0:00:19  0:00:19 --:--:--
>> 5938k
>>
>> pushd ${TMPDIR} >/dev/null
>> + pushd /home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted
>> echo "Verifying checksum on linux-${VER}.tar.xz"
>> + echo 'Verifying checksum on linux-5.11.4.tar.xz'
>> Verifying checksum on linux-5.11.4.tar.xz
>> if ! ${SHA256SUMBIN} -c ${SHACHECK}; then
>>     echo "FAILED to verify the downloaded tarball checksum"
>>     popd >/dev/null
>>     rm -rf ${TMPDIR}
>>     exit 1
>> fi
>> + /usr/bin/sha256sum -c
>> /home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted/sha256sums.txt
>> /usr/bin/sha256sum:
>> /home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted/sha256sums.txt:
>> no properly formatted SHA256 checksum lines found
>> + echo 'FAILED to verify the downloaded tarball checksum'
>> FAILED to verify the downloaded tarball checksum
>> + popd
>> + rm -rf /home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted
>> + exit 1
>>
>>
>> checksumming the downloaded kernel manually gives an "Okay" though.
>>
>>
>> is this just me (on Fedora 33) ?
>
>Fails for me on Arch:
>
>Verifying checksum on linux-5.11.4.tar.xz
>/usr/bin/sha256sum: /home/gregkh/Downloads/linux-tarball-verify.gZo313NCk.untrusted/sha256sums.txt: no properly formatted SHA256 checksum lines found
>FAILED to verify the downloaded tarball checksum
>
I can confirm it works alright with me on OpenSuse Tumbleweed and Slackware
...yet to test on others....Debian....Arch and Gentoo ...
>

Oh btw ...sometimes I got that specific error because of lack of dns
propogation to dns stuff in some reason...


>Konstantin, anything change recently?
>

--i3HbxQlc7lFrG8j3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmBFWtcACgkQsjqdtxFL
KRXtWwf+IMe1Li8fBwRLDuOOuZYdeSaki/BPoJdOZ5qBuxoIkSF1BOgj8Mj8D5JJ
SuzZ8HkWop0AUJBj0Uhd1XOPmfG1Agul5/P96jqh0Izl1c2AEXBFk3vfHwnrPK4O
qoq49VhlgKI7xny6lzxUt5uPWW6nbRel86Cn+4WM9FAeTYE1gMJ9KMqWPRh0UWw2
opjxGpRIyplpItUrslq3rSbOqz6Capr1tEbY8cgmbVI7272LoZmblfJN9sRQXQ9a
9n/qp73ODjU64gH5hfk9oNY1W+yCbmB6oPCOsJWvgmgdQuE7ycuiMU26tq+Bd8Es
oaJvY4X8pU66trcYB5wp/0VVzC9IZA==
=7Uho
-----END PGP SIGNATURE-----

--i3HbxQlc7lFrG8j3--

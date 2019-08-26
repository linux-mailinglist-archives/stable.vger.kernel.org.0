Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990229C8BC
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 07:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbfHZFmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 01:42:13 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42938 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfHZFmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 01:42:13 -0400
Received: by mail-pg1-f196.google.com with SMTP id p3so9866895pgb.9;
        Sun, 25 Aug 2019 22:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LHpOT5PJ300gSASvUTzy+HqNdfPhyWzS2boZy8pqZjM=;
        b=DliSNhEL24x5j4/FLs380QuOYK/6BCZ4Oi27/6qeazJihR64ZlMNzlitHQfOn6Ooj+
         ZbXve2POs4o7gvxjVlXXsLEvk/WoX0OUIoa1b0lg01iFIIt3DLrOJirjM1V54dWbKjlG
         uuPq6GSyMTAxb0o8aFTtrdLB5kxFLcWDISQ74UqUc320aDDi2qYtdT/XzXFZpLuZUH3A
         jKQp5KBvKPCTt4NC8l6xnHKdky2bqS5tBulste6xWfhdj9EVMCKkw6y0swifGeHxkFZJ
         WqSEVGPeD+iL7238tUXdXAEBZiyzdgz0WZj52IJ3Y5xj6rcbpAYR23B+9rUxKHhlgAaF
         7Clw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LHpOT5PJ300gSASvUTzy+HqNdfPhyWzS2boZy8pqZjM=;
        b=f1HvFf+hxXr/G8eJBVKvVNWWMbTmPKUmfPAv5G91qMyK7oZL/0ld2XDjDRB+IBO+n3
         Dyee1KKISto74Gk6+aldlrP4a5oJRAMJBtDNKSdY518h5omNeiXMt67t5rtBJV4E3ren
         rVbTlr9wLbEw7S+IMOhICkNR2zI4mdm+HzhyTvEgSNuMp7uQUOptO7Ux+s8Z3/njMXck
         E6u/QL+6wNpJVN+3Yl06zSv+zmG5sTOf06Sqp5VFW1iOosA+VOqAFJTA25weGlbhqTIJ
         4d0B8D4G91gXLbO6/DeN5h/4owQDFZ0i8qzQCHR5J/OCoiwIOq4a5udlh2dmFTJJ1BFX
         OYgQ==
X-Gm-Message-State: APjAAAWBGESKGoPVnzWjvjiP8sFx9up9V2zt6TdEiS96IJfgtGy4Pk7/
        VaF2Pi9ts5E8LFxTxIIYg3Y=
X-Google-Smtp-Source: APXvYqxxLk7dvE8steWoKmU6uxcpyA322+pTWJ0IxJflLkyYogbCFgb3nolh67radeNPPwr7k2YVNw==
X-Received: by 2002:a63:4e60:: with SMTP id o32mr15108620pgl.68.1566798132785;
        Sun, 25 Aug 2019 22:42:12 -0700 (PDT)
Received: from Gentoo ([103.231.91.35])
        by smtp.gmail.com with ESMTPSA id i9sm17843064pgo.46.2019.08.25.22.42.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 22:42:12 -0700 (PDT)
Date:   Mon, 26 Aug 2019 11:11:58 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <greg@kroah.com>
Cc:     Paul Bolle <pebolle@tiscali.nl>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, jslaby@suse.cz,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: Re: Linux 5.2.10
Message-ID: <20190826054156.GB31983@Gentoo>
References: <20190825144703.6518-1-sashal@kernel.org>
 <dd3a1ec7d03888dade78db1e4c45ec1347c0815b.camel@tiscali.nl>
 <20190826043401.GC26547@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Content-Disposition: inline
In-Reply-To: <20190826043401.GC26547@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Not sure,kerne.org not reflecting the latest number...probably timing
difference ....looping Kai in this mail ..

Thanks,
Bhaskar

On 06:34 Mon 26 Aug 2019, Greg KH wrote:
>On Sun, Aug 25, 2019 at 07:33:36PM +0200, Paul Bolle wrote:
>> Sasha,
>>
>> Sasha Levin schreef op zo 25-08-2019 om 10:47 [-0400]:
>> > I'm announcing the release of the 5.2.10 kernel.
>> >
>> > All users of the 5.2 kernel series must upgrade.
>> >
>> > The updated 5.2.y git tree can be found at:
>> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.2.y
>> > and can be browsed at the normal kernel.org git web browser:
>> >         https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>>
>> v5.2.10 was tagged by sashal@kernel.org but signed by
>> alexander.levin@verizon.com. Perhaps you could use one of gpg2's many options
>> to add an
>>     aka "Sasha Levin <sashal@kernel.org>"
>>
>> line to that key. (I assume "--recv-key" then would have found your key.)
>
>It's on that key already, have you refreshed your version of it?
>
>thanks,
>
>greg k-h

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl1jcSQACgkQsjqdtxFL
KRWY3AgAkTIQxqK2dmHzB0d2R5HYXfgmmaFjLno46j1G34IRf87/hZm3MQsDq/ie
Lza/nMQYCXlB/xfxrTcPfwrmdJk7MflwqYPhddXAVv7ieLkg1ZBqYEboQ9E80e0E
7K6wWbkMzfFOzqed7W1dQhZ7ev5mzT/uEE0rX9On/OPuF9NXIvymqQXsftPRyYZ7
LW5i9jahp57yYXUTfj5RBFtOAacbAQrKyBrGN6PeHQJ2ik3khJXz4fZinWIluOnW
3UsfkjOSIOqCczqwRjjKIZwtZkboXfRrgmODjFqev9SkvMEaFAwh/b0GlJQ21qN7
eyvhe9HzBMEz94tiPmSseP+2REK+Qg==
=oDzp
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--

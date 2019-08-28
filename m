Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06F9EA0DC9
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 00:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfH1WxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 18:53:10 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36714 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfH1WxK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 18:53:10 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so494797pgm.3;
        Wed, 28 Aug 2019 15:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lf92TMYTkAV1HBDLrWcWD4AfkryDbwsg8QEPhVI9XqM=;
        b=dw9E5NT/S5IlcMOY5dmeDbu5wcqYHjsGw0cuc+o8UKOktzI5Q/Q7ydVaehF/S46CRR
         afjghwMDRWb/44PfOzEzuLNzinYgQ0fkr/mgyl0ixImwXIH8km+51Ux93z3y/m8CZaaa
         IJGYuuL0HNuud3x0ud7+gV2kzfoCm/iyxC+BCsqWQjyCBS73b+urE8IzL7AEPhjyuRPn
         8GM6UDqiBNFG75eEwdB8RwiqtP/H8V+idWCfI2nJO4rFmAJ2B8YOi1oDWo3kEBxbvEpm
         20MpxakpWdmUInkF/vjCt7un5mc600k6oH18m/j3t4hE7siPtIqFnxVfcL4pnGmW11dV
         p+fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lf92TMYTkAV1HBDLrWcWD4AfkryDbwsg8QEPhVI9XqM=;
        b=RzfX8FN6nyhdQy4BI/5/sPMhxWS/DQUYYAxTrNA71rp4BwMHYsTyXK0TnS1dIkRvz2
         zgMig+E+FWu2Io6tp/gvVmaxUvFoqnWVNwR347wNIe019rL8PS+GJWIZRCj/6Glsc0ru
         t9YqZw/ME7r8wLj2CGC8dFKeMcNJqtcpih2A3BMuxUJJIFYOPOohxEUEktmZKOhIB1OK
         n4HtAgKACfHluqS+MZjPHubCRxrM8wd2NOVChEw1OFkPvk4uLW3iYnxGpKi13/Bn1f6H
         OSorkiDsmD14VOUyA1ysDi00dmexT/oRwL8kljHMQ1sAwuHCjhgTJBncJOMkBVFwxXpN
         QLKA==
X-Gm-Message-State: APjAAAXuVzuVgYsZJ00jRX6TmQjGwrT6WJ3qTVuECzG6/lRyatUkXw/+
        9chCV+KdMbANAwTmI6g2Gv/dER03
X-Google-Smtp-Source: APXvYqwWx3LE+RQwvhwpOmj6xk6DTFbtLSJHu+ErxmoykHugwDfmeeAtpVx0t1Q+G5DwsCf3TwRLpw==
X-Received: by 2002:a65:684c:: with SMTP id q12mr5135156pgt.405.1567032789352;
        Wed, 28 Aug 2019 15:53:09 -0700 (PDT)
Received: from Gentoo ([103.231.91.66])
        by smtp.gmail.com with ESMTPSA id ce7sm185960pjb.16.2019.08.28.15.53.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 15:53:08 -0700 (PDT)
Date:   Thu, 29 Aug 2019 04:22:56 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Konstantin Ryabitsev <mricon@kernel.org>
Cc:     Greg KH <greg@kroah.com>, StableKernel <stable@vger.kernel.org>,
        LinuxKernel <linux-kernel@vger.kernel.org>
Subject: Re: Latest kernel version no NOT reflecting on kernel.org
Message-ID: <20190828225253.GA30806@Gentoo>
References: <20190828135750.GA5841@Gentoo>
 <20190828151353.GA9673@kroah.com>
 <20190828160156.GB26001@chatter.i7.local>
 <20190828170547.GA11688@kroah.com>
 <20190828193908.GC26001@chatter.i7.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20190828193908.GC26001@chatter.i7.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15:39 Wed 28 Aug 2019, Konstantin Ryabitsev wrote:
>On Wed, Aug 28, 2019 at 07:05:47PM +0200, Greg KH wrote:
>>> > I think there's a way to see which cdn mirror you are hitting when
>>> > you
>>> > ask for "www.kernel.org".  Konstantin, any hints as to see if maybe o=
ne
>>> > of the mirrors is out of sync?
>>>
>>> Looks like the Singapore mirror was feeling out-of-sorts. It'll start
>>> feeling better shortly.
>>
>>Great, thanks for looking into this!
>
>BTW, the easiest way to figure out which frontend you're hitting is to
>look at the output of "host www.kernel.org", e.g.:
>
>$=A0host www.kernel.org
>www.kernel.org is an alias for git.kernel.org.
>git.kernel.org is an alias for ord.git.kernel.org.
>ord.git.kernel.org has address 147.75.58.133
>ord.git.kernel.org has IPv6 address 2604:1380:4020:600::1
>
>The three-letter airport code should indicate where the frontend is
>located (in my case, ORD =3D Chicago). There are total of 6:
>
>sea.git.kernel.org - Seattle
>lax.git.kernel.org - Los Angeles
>ord.git.kernel.org - Chicago
>fra.git.kernel.org - Frankfurt
>sin.git.kernel.org - Singapore
>syd.git.kernel.org - Sydney
>
>Geodns magic should send you to the nearest one, and if the monitoring
>recognizes that one of them is down, it will be automatically removed
>from the pool until it recovers.
>
>Best,
>-K

Hmmm...thanks a  bunch!

-Bhaskar

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl1nBcIACgkQsjqdtxFL
KRWi1wgAuvEXO/Ahnx4ym2L5zqYLR9yUyzXeqUorHqvw+idy/6U+blph1ziFurum
DoxFhwbyWeMdIEFecN99GfUl/Qvvbla6JjdWE27SVDFdQjKzb/+Ias2jqPwwmulw
lA2WAkXrbWhuLX3W3Y5VgpYrWvSVDxmmjbx+zzIQ7Iqdom3bFzvNScihrjeDHkW9
/OMecNBD5F9lqz5OnjD/6GYPqK17hnObgej8oOq8GWsFwzjWHa4yuLCzSSPgCopc
+sezLuyiSXvCcW0fLkS/tjLU4APrtQZ21YyIv9q53GCJAcNxuBrl0ksAJBQocna5
9phftZUy4rUrhw19lHA0mF/FS8ToTA==
=uEaJ
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--

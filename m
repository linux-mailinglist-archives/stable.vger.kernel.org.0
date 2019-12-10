Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C44501196CC
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfLJV3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:29:15 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50338 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbfLJV3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 16:29:14 -0500
Received: by mail-wm1-f65.google.com with SMTP id p9so4849580wmg.0;
        Tue, 10 Dec 2019 13:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=FG/XZKIFSMMTDUz+JIMGQpdpmGDcAae/yQlubLTKfz0=;
        b=pT1+e13mG3d8gvRjhN55ZWLQyc0EHeXc8FG8iRNGPsEtyIgs975QAMCTfRU69yuapI
         cDeFSAGsi/F0qb+Hcn1c/zdDVgq9Ce0q62aKOiVXE+PVmDnfDeB69/scO8yGHBrNeRK+
         HVS+ni/CwxPNRCGN059BD1pR+sX/H7H3xL7IwQn05I/d1IC4XT14gwRgZ1G+caUgMXIi
         WpU20ToqbUIkxEaAtwBn3oNxOav6mrewHbxP54q0LlBWCI9bgHfMlPGBzLX+gf8Cg6/y
         v6ByWpgQlozroQMKXRo343ZdKI7jU1PpH5cb2wspnjjXkkfNJULzXzvR698BdagPS3yD
         nsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=FG/XZKIFSMMTDUz+JIMGQpdpmGDcAae/yQlubLTKfz0=;
        b=Xgn3kcS3neSyzD+1G2qzHoReygzOKSMBZNF08TxVwLXpuY5JwxIBU+ZplWb37WV91h
         +Ul6UKaD2rX8nvL1I/lNONP69uGIChEf6RBK6l/9Uf0lYMKJSkaKwoNciG2Oh5bllX89
         CAy3hkqMXwDJlK3wuNEUsV7L56mFKMJkqZpkt9Fom0j/b4HJBEnZfD5JGdXKF7PljifD
         VBgp5p2o8YuZWLB/MYeDwaydDmzRdKIxVusuRq15BaLbeCXM5RmKFMhK6GK8q3im6NqA
         pJrh48YekGA8i95juiC0dst8XbeJLgTGq/OIUWMXId3eGXMzLPz4vN93h5gJphH34xTT
         MouQ==
X-Gm-Message-State: APjAAAXS4SYe+6w35u3tHPnmnNSVbsDvDQu1tquToSbXxZVYVovt5+Up
        TBatowsdPG8BmPBAEdyWWrI=
X-Google-Smtp-Source: APXvYqzV+LatBQfezPk2Eegm4eL7MJFg3+zlDs63o1pYh2mpvtO9ZXoEeVhIS17IngnvAsPbrk6Q8A==
X-Received: by 2002:a7b:c955:: with SMTP id i21mr7261918wml.172.1576013352456;
        Tue, 10 Dec 2019 13:29:12 -0800 (PST)
Received: from [192.168.43.162] ([109.126.132.112])
        by smtp.gmail.com with ESMTPSA id x1sm4632142wru.50.2019.12.10.13.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 13:29:11 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org,
        =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-2-axboe@kernel.dk>
 <e562048a-b81d-cd6f-eb59-879003641be3@gmail.com>
 <15eb9647-8a71-fba7-6726-082c6a398298@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFmKBOQBEAC76ZFxLAKpDw0bKQ8CEiYJRGn8MHTUhURL02/7n1t0HkKQx2K1fCXClbps
 bdwSHrhOWdW61pmfMbDYbTj6ZvGRvhoLWfGkzujB2wjNcbNTXIoOzJEGISHaPf6E2IQx1ik9
 6uqVkK1OMb7qRvKH0i7HYP4WJzYbEWVyLiAxUj611mC9tgd73oqZ2pLYzGTqF2j6a/obaqha
 +hXuWTvpDQXqcOZJXIW43atprH03G1tQs7VwR21Q1eq6Yvy2ESLdc38EqCszBfQRMmKy+cfp
 W3U9Mb1w0L680pXrONcnlDBCN7/sghGeMHjGKfNANjPc+0hzz3rApPxpoE7HC1uRiwC4et83
 CKnncH1l7zgeBT9Oa3qEiBlaa1ZCBqrA4dY+z5fWJYjMpwI1SNp37RtF8fKXbKQg+JuUjAa9
 Y6oXeyEvDHMyJYMcinl6xCqCBAXPHnHmawkMMgjr3BBRzODmMr+CPVvnYe7BFYfoajzqzq+h
 EyXSl3aBf0IDPTqSUrhbmjj5OEOYgRW5p+mdYtY1cXeK8copmd+fd/eTkghok5li58AojCba
 jRjp7zVOLOjDlpxxiKhuFmpV4yWNh5JJaTbwCRSd04sCcDNlJj+TehTr+o1QiORzc2t+N5iJ
 NbILft19Izdn8U39T5oWiynqa1qCLgbuFtnYx1HlUq/HvAm+kwARAQABtDFQYXZlbCBCZWd1
 bmtvdiAoc2lsZW5jZSkgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+iQJOBBMBCAA4FiEE+6Ju
 PTjTbx479o3OWt5b1Glr+6UFAlmKBOQCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 Wt5b1Glr+6WxZA//QueaKHzgdnOikJ7NA/Vq8FmhRlwgtP0+E+w93kL+ZGLzS/cUCIjn2f4Q
 Mcutj2Neg0CcYPX3b2nJiKr5Vn0rjJ/suiaOa1h1KzyNTOmxnsqE5fmxOf6C6x+NKE18I5Jy
 xzLQoktbdDVA7JfB1itt6iWSNoOTVcvFyvfe5ggy6FSCcP+m1RlR58XxVLH+qlAvxxOeEr/e
 aQfUzrs7gqdSd9zQGEZo0jtuBiB7k98t9y0oC9Jz0PJdvaj1NZUgtXG9pEtww3LdeXP/TkFl
 HBSxVflzeoFaj4UAuy8+uve7ya/ECNCc8kk0VYaEjoVrzJcYdKP583iRhOLlZA6HEmn/+Gh9
 4orG67HNiJlbFiW3whxGizWsrtFNLsSP1YrEReYk9j1SoUHHzsu+ZtNfKuHIhK0sU07G1OPN
 2rDLlzUWR9Jc22INAkhVHOogOcc5ajMGhgWcBJMLCoi219HlX69LIDu3Y34uIg9QPZIC2jwr
 24W0kxmK6avJr7+n4o8m6sOJvhlumSp5TSNhRiKvAHB1I2JB8Q1yZCIPzx+w1ALxuoWiCdwV
 M/azguU42R17IuBzK0S3hPjXpEi2sK/k4pEPnHVUv9Cu09HCNnd6BRfFGjo8M9kZvw360gC1
 reeMdqGjwQ68o9x0R7NBRrtUOh48TDLXCANAg97wjPoy37dQE7e5Ag0EWYoE5AEQAMWS+aBV
 IJtCjwtfCOV98NamFpDEjBMrCAfLm7wZlmXy5I6o7nzzCxEw06P2rhzp1hIqkaab1kHySU7g
 dkpjmQ7Jjlrf6KdMP87mC/Hx4+zgVCkTQCKkIxNE76Ff3O9uTvkWCspSh9J0qPYyCaVta2D1
 Sq5HZ8WFcap71iVO1f2/FEHKJNz/YTSOS/W7dxJdXl2eoj3gYX2UZNfoaVv8OXKaWslZlgqN
 jSg9wsTv1K73AnQKt4fFhscN9YFxhtgD/SQuOldE5Ws4UlJoaFX/yCoJL3ky2kC0WFngzwRF
 Yo6u/KON/o28yyP+alYRMBrN0Dm60FuVSIFafSqXoJTIjSZ6olbEoT0u17Rag8BxnxryMrgR
 dkccq272MaSS0eOC9K2rtvxzddohRFPcy/8bkX+t2iukTDz75KSTKO+chce62Xxdg62dpkZX
 xK+HeDCZ7gRNZvAbDETr6XI63hPKi891GeZqvqQVYR8e+V2725w+H1iv3THiB1tx4L2bXZDI
 DtMKQ5D2RvCHNdPNcZeldEoJwKoA60yg6tuUquvsLvfCwtrmVI2rL2djYxRfGNmFMrUDN1Xq
 F3xozA91q3iZd9OYi9G+M/OA01husBdcIzj1hu0aL+MGg4Gqk6XwjoSxVd4YT41kTU7Kk+/I
 5/Nf+i88ULt6HanBYcY/+Daeo/XFABEBAAGJAjYEGAEIACAWIQT7om49ONNvHjv2jc5a3lvU
 aWv7pQUCWYoE5AIbDAAKCRBa3lvUaWv7pfmcEACKTRQ28b1y5ztKuLdLr79+T+LwZKHjX++P
 4wKjEOECCcB6KCv3hP+J2GCXDOPZvdg/ZYZafqP68Yy8AZqkfa4qPYHmIdpODtRzZSL48kM8
 LRzV8Rl7J3ItvzdBRxf4T/Zseu5U6ELiQdCUkPGsJcPIJkgPjO2ROG/ZtYa9DvnShNWPlp+R
 uPwPccEQPWO/NP4fJl2zwC6byjljZhW5kxYswGMLBwb5cDUZAisIukyAa8Xshdan6C2RZcNs
 rB3L7vsg/R8UCehxOH0C+NypG2GqjVejNZsc7bgV49EOVltS+GmGyY+moIzxsuLmT93rqyII
 5rSbbcTLe6KBYcs24XEoo49Zm9oDA3jYvNpeYD8rDcnNbuZh9kTgBwFN41JHOPv0W2FEEWqe
 JsCwQdcOQ56rtezdCJUYmRAt3BsfjN3Jn3N6rpodi4Dkdli8HylM5iq4ooeb5VkQ7UZxbCWt
 UVMKkOCdFhutRmYp0mbv2e87IK4erwNHQRkHUkzbsuym8RVpAZbLzLPIYK/J3RTErL6Z99N2
 m3J6pjwSJY/zNwuFPs9zGEnRO4g0BUbwGdbuvDzaq6/3OJLKohr5eLXNU3JkT+3HezydWm3W
 OPhauth7W0db74Qd49HXK0xe/aPrK+Cp+kU1HRactyNtF8jZQbhMCC8vMGukZtWaAwpjWiiH bA==
Subject: Re: [PATCH 01/11] io_uring: allow unbreakable links
Message-ID: <75ef6963-a9d7-33ef-cfdd-9770c09fc266@gmail.com>
Date:   Wed, 11 Dec 2019 00:28:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <15eb9647-8a71-fba7-6726-082c6a398298@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Rfl9zpAbw7BYzuX3AB1wwbpw7gv9487Xs"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Rfl9zpAbw7BYzuX3AB1wwbpw7gv9487Xs
Content-Type: multipart/mixed; boundary="wjofozT2qlxaGPflrivFiHv28simLHqDQ";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: stable@vger.kernel.org, =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
Message-ID: <75ef6963-a9d7-33ef-cfdd-9770c09fc266@gmail.com>
Subject: Re: [PATCH 01/11] io_uring: allow unbreakable links
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-2-axboe@kernel.dk>
 <e562048a-b81d-cd6f-eb59-879003641be3@gmail.com>
 <15eb9647-8a71-fba7-6726-082c6a398298@kernel.dk>
In-Reply-To: <15eb9647-8a71-fba7-6726-082c6a398298@kernel.dk>

--wjofozT2qlxaGPflrivFiHv28simLHqDQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Remembered my earlier comment. If the intention is to set HARDLINK,
must it go with REQ_F_LINK? And if not, is it ever valid to set
them both?

That's not like there is a preference, but as it affects userspace,
it'd be better to state it clearly and make code to check it.


On 11/12/2019 00:12, Jens Axboe wrote:
> On 12/10/19 2:10 PM, Pavel Begunkov wrote:
>> Apart from debug code (see comments below) io_uring part of
>> the patchset looks good.
>=20
> Hah, oops!
>=20
>> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
>=20
> Thanks
>=20

--=20
Pavel Begunkov


--wjofozT2qlxaGPflrivFiHv28simLHqDQ--

--Rfl9zpAbw7BYzuX3AB1wwbpw7gv9487Xs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl3wDhQACgkQWt5b1Glr
+6WC0Q/+Oynl/kf1rEGZF7BLJXDS6MoPqPneypoFQv2o8H7OLRrAtsbjS7HIexyV
AT7Qc2QBZ2FsWCqknfk+M3srT/GflFStbGTI1sRSfISHZb+lpDkOXxFUJ9xP4v06
qyrF8HjWGvJwYvFhUQPEuyCDmKPBj1ZmBEKCnfNCJkopAZv17IXjH3xL+exSomuP
0wepVMZM0h9bQYWCg06dEIL1t+8qazeS2zSCk8HAxwqxJ+D8GyG5jnGuje9VpPkc
UGnSDVfjf6EhZoc4PKu25WZZNJTZkKDnx8HgSUtrD/CnOwudO60pW9i1UT9m+YmP
WfYZXZkLI4RWV1Mwje98f4kqmx4Npixd4GZpx9ziz+QzPTVQwpmzGDzcMmRkkpjZ
F0b2E2I6Ekjl12yeu/xweB+8mdrHqt/UkWEiiUptFfh8kZYfKjJxOhUEBYdN6xUc
V2+seh5tg8pAQMkm5GjB8i+0KNd84ygNY51WEKwsS8gbQP2nGT2vlWWVQePvIKEx
XfGAlpSW+xYNtvcoolscr+kI+72TZkA0YVdmnnXDzNd1zHGqu8tPpDpHFplbP8Tw
08on6qFSYQTbh56hsT97sRB3pMDoa39LrZI1vgJweE1WsFT6Sx62B7VoI58eDmr/
OFfwCdLgMteT/GsX7CXSQCbTQjH9neiy/PIxGulW7+uTK20SRhw=
=O8Lf
-----END PGP SIGNATURE-----

--Rfl9zpAbw7BYzuX3AB1wwbpw7gv9487Xs--

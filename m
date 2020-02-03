Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDAD1501A1
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 07:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgBCGTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 01:19:09 -0500
Received: from sonic305-35.consmr.mail.bf2.yahoo.com ([74.6.133.234]:41896
        "EHLO sonic305-35.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727222AbgBCGTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 01:19:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1580710747; bh=VxFSqOLnoyhxZXWK73TPGK3hr8yutZ4yWmLQa/jSY/I=; h=Date:From:Reply-To:Subject:References:From:Subject; b=jMYsWUIz9jSPgRJWdM5YrkbNoMo+WoVNIOzTW901kYjTc1Su4AI81KWfnxBJnUg4s1DzhfV4heqWSOSJMWqUdTjeDTQv+iVKT8k2mK6kbzK3In2/ss15On/QRPXkby/dcQjJezsuc2NppgBEUaqfQcwsFmPUpF0YWTvWXXU70X48I3gV43zoRFXhGYTWudgzDjUG+7zI2c750lRYYppz4ev/8DgoJr4vO3+Ow+IgQkY3YNZEu6sd6Gsgf0vV7Jnacc3V5FBk5wjPpAuQqjVaO/hsDQTcVaFV6R6uq3MUh52LUrmIBBK1RB3kH4j2oc6KVMmAK6aq/055dXmSqneWWw==
X-YMail-OSG: eq7d2AMVM1kvjbSh7DzsmANv4dJwK.wcGrvWBk2_JUlB_W1Lm91y5S3XNY1jpak
 HPxnuuwaA6szB0jUSngc55Uv_vHBxGCsIfbNr3Jo9HGejvI8OQS.ei0Ik8jVRj1.BLrPMIq9EaWP
 QEfXHsoZAALc4z365ysUIt4.rFkg7DjxzO_rZ64kY6xUz5YIdGvAeiYwIDLoEBh5km4ReTXAyLcR
 rqvNTa1hmoiDzsYIPXXbFLkXbxCnRE9xLlCYoji0UoAblLDhUD99Hwy.poI8.26aWy9wftEXckIy
 EbW5BbqkCl97ygHQWrQaLJYWZGrR7ABYJZlwC6xdA5Wws4ICbF1Rq5KW6Xso1cGK6FsxVU0wI6bd
 1AC3YKm60ejrzI1N71JQscB6fff.r8Pa783OQGRb1x6Pq6OI2f92JRBFhxVbEcFzaIB2BQV4JMSc
 yn7owBMiYzopFIDdKhT8C5ZOohPbGXddF2yuSfpyNU1o3jmKLJY9ZqPOOX9xk7DtDjyliGfZPk7_
 pejghjF60izuLEGKsoqQOI9JMmYMXSi6bh64_VcFc5R94qSH9M4wM75KYKv.Dc3y3MY7vXrQfh2l
 N.eLMcgyO5atQ8MB2OFWgh4MAiiUMD6oN_vJp3QPLDgY_Q9ZgM7znyhkjaojPxQhGLLShQY_6IS.
 Xs_rTidBQAKGISWr.G236OJuNiK4dFpKwoJT1p9KPNvH.8Ndm8NTPxj.xrYr8iChTgaABZHbSrq_
 TxlJoiL6Nt1XU4sGwn4WHAUbdxE5aQ.hXi4_ueBevzxfGErBmBptk3jdGvqF9veE637fZuE332GG
 mBjKmk0cA2Zf2VNoyZysN_RrTS45MbKMsuHidL5Yl1t0vcO4sLiDlcAn3S4eXmT2tPQemuCOky3R
 WcwO9pOFuhxlj7M2iPT6uhW13BxZLaY3uOeuCH6DDHBMRaAKSDUIVpVTalUsefX2CbFZn8vlp3QY
 6j6aAUGwlk..4VuZX2Q6PhtyeFtUTXlGjrJGB4cZXrGG8KKDmXO4vXAAuV5BuxuNERDAE3x77GUq
 oaDf.YwTNjr9nbCaXFplqV.5Us4OyyV.ZYNCM61GRX2_.kb7qeDLrtEjECicTl94hYPUOjdeXMVf
 1rlAlQPKpi40WVQI8qn83eXM98ds2uwRBIOwqyNJEr2bxImC5LNx0n053f3C2c6HZP5UcQAVz8YP
 43qumpLvqmZ_pzpY2_RoegvSAZRwRnOlmrn3WRpNH45oo9LbJIBLKmB7lA8Muwpt2YHrA5pw4Mwp
 VQVlevaX9DK.ieA1zUVjW8_2IVfvQZotydrTzRmOn5DDHHQjb.KFHyvQ65T8Q1HWuJESFtpLm6gC
 vme_tv10yn7ZRldXvPIFvXDghAYp87QMcLw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.bf2.yahoo.com with HTTP; Mon, 3 Feb 2020 06:19:07 +0000
Date:   Mon, 3 Feb 2020 06:17:07 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <dd45@gczao.com>
Reply-To: maurhinck6@gmail.com
Message-ID: <45297831.595640.1580710627062@mail.yahoo.com>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <45297831.595640.1580710627062.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15149 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36 OPR/66.0.3515.44
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck6@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.

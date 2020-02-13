Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF4415C4C9
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388009AbgBMPui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:50:38 -0500
Received: from sonic308-9.consmr.mail.ne1.yahoo.com ([66.163.187.32]:44812
        "EHLO sonic308-9.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388095AbgBMPuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 10:50:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1581609036; bh=zI0m+DRhZDm01EKX+YHsQU600DuE8AwybL7Vu4lblwE=; h=Date:From:Reply-To:Subject:References:From:Subject; b=f97EdySP9j31KkifAhkhs8DvSDTn1/a1fmHrWYLtbW2UVuwl+RlgJmrc+8kjZ2DDz4V97lloTCayJkn0r3XvxGqX5m1Da9kbmAgdd69NoMqLgrrZjsU40tS1ArCC1LDs4Qwus1DKJ4xJHDtjCiEKW2CTx9OsX3jDkBrzrypUiDC5acUTghbXEryGfTDL4X75xfvUJwsPaW2UGMr3PngpTDUEAZt9UDvt1ic/OxqYug/ISFWBUs4rJuQKvY+NbUhPX35Jf204U5JI3A0gaFgbIpB4YrQyNbjEvhccMLG8qcUwrbBOmQjOkyypegjyRHxRGfj+fLlziOXRzIzgvLaNfg==
X-YMail-OSG: _epZ2x4VM1nK2PlykU6JoroYQUXFtSOhGSqjP18zEHKP1_42uF_HmdDKEs.hZCo
 B1Vkrlbgxkoe2DpC0vyJn2UdeBewIW8zHSNQDZOrnlVRvb6TZLH4rFsO_cg.TNTFuYcU0iI9utq4
 US.647k6soFmFdSBjfU7Mp5mxN1rJU_42NXc7xJE94LM.ukDhjxmGHU_ivvav8C7.pYBJAcUvJ17
 XiW1xt6vBqabM8.tfFfmKXnYLwUYOYxauL5_awVme8sdbEZvPyHVjgv1XnmfMNEwT4a5Vx2AG13E
 hL5kVBdvW2YAS_kwtaNuJo1b_67S7W9m226zdqQqaTsIDcsSTUO.oE69k_D23uSGt0a7jNh1.eVo
 oMS20ZAh0bIfYrQCA788jBSTb3Dgx5Yb2U4BuxAeHgjRa_oro6w4jdEDPSKwyUyznS_V6RjgCTfT
 3JKVxePVGIACqQ.t84ihzVItBn.lUJaKjBiCOFMr7g1ZRtBmHmiZrBcLycRIPQTurZm4rtJESePi
 6ff62B1b2qQyl.6o9tRLx77KUOfCDZjgCnGTT6DObgfYWzYvqIRrDtHCxPxCgHZs4kv5Pu6IzmCT
 xF1Zr9Sim8RbcnbQFmsaeu2FrmyN4EZZ0JTxTKxAsA5eEvKV5yGXktfjc6.4RBOHM7XnNJja1rS3
 zSXN2vZ_kiagki3h6CY7N8xTLZ2LDd6BFv9.n0ZbBNk.Bfkv0Nr.JAEIJ4Nx1lXKgCvqqIIU.nQM
 10aIvZbe2G8XAz41tJZqEiBvfa0yqIWoTRwdNSurLm.ivLxxVqHxSPWrbvIekh2NHei0dRcy4wsR
 YGIuT9Ez5gx9NPNhlm371wYQmihOlzcSGlJCMwGcuVZU6tZ9tLmBHi8eCLaOd0jvY0PqER45agnU
 RJGJ7w0l469Bu2QC0QrYn.fuUqqf8MdBS4fQRuGgOGpH1XcdHQ.8gKWDUE7bQK_PdtcqDB1oX8bQ
 VNcKg2rt_r1ik5G1URzBLt9g1RUjYTrJD9phLn.hWj2ptDbT3rhDIenYSijdhdXvs46JANJox9nx
 fHSlah0uQxfXpRYnY3nWC.A2mXwUNUBi2cnsKHCnL0fLSLx99k.0l9XwSrvKmxhKZxFcajk_cwrz
 3qhqKTsuI1_ghEOHLF3mB4Q8rBSzxT0v9iuxxyaBnKpyxAFDF.jxkojRVJWm8sgAcROXzztauIX0
 aLP5_vOWMqe85nlXiinEf_00hBx8aCuRsvi910TkGPutOrYIK5FMMnrUsSJxmhGWXcix6Mnlpr_u
 t0gqG2J5GYxuk24UwWt5UtmArJ7lCHK5qGlNs7iQ2LJSYZrJEYdulgmCQVquAYA6h3lbrkY0Vwlb
 .1obnmZU-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 Feb 2020 15:50:36 +0000
Date:   Thu, 13 Feb 2020 15:50:31 +0000 (UTC)
From:   Lisa Williams <lw3628517@gmail.com>
Reply-To: lisawilam@yahoo.com
Message-ID: <1148996542.2532773.1581609031970@mail.yahoo.com>
Subject: Hi Dear
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1148996542.2532773.1581609031970.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15199 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:72.0) Gecko/20100101 Firefox/72.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Hi Dear,

 How are you doing hope you are fine and OK?

I was just going through the Internet search when I found your email address, I want to make a new and special friend, so I decided to contact you to see how we can make it work out if we can. Please I wish you will have the desire with me so that we can get to know each other better and see what happens in future.

My name is Lisa Williams, I am an American, but presently I live in the UK, I will be glad to see your reply for us to know each other better to exchange pictures and details about us.

Yours
Lisa

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8752827959F
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 02:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgIZAfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 20:35:54 -0400
Received: from sonic313-14.consmr.mail.bf2.yahoo.com ([74.6.133.124]:44472
        "EHLO sonic313-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726687AbgIZAfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 20:35:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601080553; bh=dmrXGoOcSWMF2SnlezJ+xBbgkxN4SQugvVtmdIdRXqU=; h=Date:From:Reply-To:Subject:References:From:Subject; b=QB+CllgILpDVEOXaXfJdYzhC63dnsXSAH35vZKttYfols1aNiYyHLTa8EQyOmVQdsbnm21CNn55wSJ7vJ+yOa8APABMjqWUPxyEGew1EaStQlBmpqFcITPztoe3y6LwbH0CX8DObGDXTXjPKT/ugqgO01MR8UyT5Qhix0RjWhqyG4sW6waSyJn+O4hFDaXgaYwj1Kq2BD+d2cCX+Pg4Eh7rwL6l1PkmCbo/yZwntgEZ9cIcIPpkTAwdLXSB0HINmAnKRgwu+iacZ1JGWJ316oGLAdX4+8Sb2SW4+CuNbkgfHa7S00SshncqRJd9gDNc/pizO/PRc6WYDzaAfOzQV6Q==
X-YMail-OSG: uMu2XEwVM1k9V3NaDGl6vvq8kQRNk9qlDVUIH9iGPSL6V1PIQymH3O_aJ9NHdFu
 BEtBuCsfoEdkgv1ehx32zKi27VFf8q2qzadVRNvYGFnMH1Pn2EhHK501Qv3Uu_8cGukjbdnFAeGn
 ge.o.nn0o_WiQPxDDFOgeHBZbnO6NniRVOXJPznakopo.gfSTzfkBOv_OBhRQM.6M_nnfteujOfu
 6g6tSFd9HVjnj1poNrv6J6ucNvMc6fy_dxEHYP14a4Gm3_c5LcZzB4yaI2YTjNVETobOLLy6y7.x
 ZahQFe27.BxUTM2fqw.lxK0WiqKjfxi0yPlQzYE0ISDNZOejIv790SsOHC7dgIQSQFCkHOtOaLkR
 0VATd3TpxpkNA_tT_4V2AdUtA4CE4jHSDqndMTb4xV7rNgLH6gfxXnIQJoY6IBnhTKbF33uq6kiK
 1gB.7JhLHRgt68jia8HlBDYNgxHWRdEzdiG8XswrbS23RR89Iik5jWRpQJEdcgBOlqzpsEINjvRj
 7PG8bpZdUrpAVFIn64afTK3E2fMRUozF7f2WaFg1dIQCIn_VbJFDE2SfTTiJjbQSIhky8k7RV.XO
 dKjxxatuIGsrTn70jiiexVVKMpZvqPDMr0_Mu0A8v9ucF6_.vaDFCok22WGnOyV1riPXyMJepWcF
 IAT98cHR3n84EvpBdNhtpCEtucT9cPwZEBYoLMjbzxQkboYmtPAaSW8p3gEB7AQzmKNb7FynhqoH
 quTQlvVsTZY_6y7XLRCs.2jjiDU0cYf5bKQh_l04MLKp0kgri7Yz5krB5qMTsEHD5sGoitSGU1nc
 KtEFtaqH79hCX7OfeRzeHTMw7EJDDBQEmyRWieSOAiELVIa1LfWEAuYXACreaUkop9qFN7uiBwVF
 AHKH20D4UvRSTtaO8hOpxltpQpaLVhn2cXQKnQRHcuuXWaISs00M0BiAXnbWUULoFW82bUG9JLKk
 O86HGm8Owl1TaLVKVmIuHwGNb9daDY1coyIzpGVJlNcnqzFvNtyW0HhvFMnal15PRZJUy2LwtK74
 tf3MklSQLfFy5ZSfqlqyNTpd9mC4nmb7BuGaZd4BT7kydib5Zg1z5tMVWPmr_xnjKje.cohFwI2F
 Iktw.8sb2jFHqLTpyHGipLz9Zmxwl.57DwvmpjsIX5W.CKZmwm.dJWmAGT2zbQDlT_ED_jeP30Ug
 KiV7AnY9aYDCrhFeq9CC4mWVv48z5z27Yh_Qq1hT17kpN64TooVDmfINJDFrBzCylgJahtBwBuWK
 YUiiVoMqc1a33F_.bwy77yfZRFMRxVpVuGFWtIsLBNNYf2Pd7sMkXBWB1tRyUsY8oo2PIisvN3Vk
 ravR01JhUUMHwyx3mE2_NvU6NaPQ.V7iyuR9GcqJ9mMd2ahe5qH.zHrMLZQo.VPZBrBNruVIZAWT
 i1C2A_kStMtdKf0azpEhH9aeFb3pAGDC56CzDwR5MjgzR2j2ZyWk0pQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.bf2.yahoo.com with HTTP; Sat, 26 Sep 2020 00:35:53 +0000
Date:   Sat, 26 Sep 2020 00:35:49 +0000 (UTC)
From:   Lila Lucas <lila.lucas1112@gmail.com>
Reply-To: lila.lucas1112@gmail.com
Message-ID: <957393988.901720.1601080549260@mail.yahoo.com>
Subject: Very Urgent
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <957393988.901720.1601080549260.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16674 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 UBrowser/5.5.8807.1010 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



 
Hello Dear,

I am sorry to encroach into your privacy in this manner, There is absolutely going to be a great doubt and distrust in your heart in respect of this email, coupled with the fact that so many individuals have taken possession of the Internet to facilitate their nefarious deeds, thereby making it extremely difficult for genuine and legitimate business class persons to get attention and recognition.

I am seeking your assistance for the transfer of Fifty Two million (US$52,000,000.00) to your account for private investment purpose.

I look forward to your response.

Regards,

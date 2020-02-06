Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6BC81543B9
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 13:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgBFMFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 07:05:48 -0500
Received: from sonic315-13.consmr.mail.bf2.yahoo.com ([74.6.134.123]:46327
        "EHLO sonic315-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727138AbgBFMFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 07:05:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1580990746; bh=0onze4TQC/USzygNKGbb2osAuaZYJtFnmxDgBBbrRAs=; h=Date:From:Reply-To:Subject:References:From:Subject; b=OHJcYhbtdZ4gMfOh9VbvKYduthrCgMfsBgnKqWjwZZEqLzhmVgVQy7m/g9VpaAXGeSliM1l4C3P4MSIKBin5nzIIduKk1/Fifn5GcEdxoRRPyDUu9cQ+D/JxapR5DtG8qp5GpJsDgLiUovUaE6dFiHjXCp06zb3Thy5XEpEHrGg36UADa1FRtvJW5ArxhkBbhev5i2/3Wrwks0bpaYXbGsn9qU/0UyQyhwpEU4W4Mnfv5WbvLYVdrmLIbAbN74aZQK4QALP/QNbcKHIc+qyQG/7yym/K2qYwHsyXSwEOwD5YGfNgcbdIPaDyQ7nAdCbDDYvRgsvr9Z5bcY9r1+kovQ==
X-YMail-OSG: CJcDsAoVM1kBJkyoJT8yjI12t_9Okk_BscS3yAs8nqdkBk2UydvTK9joIeMcMLR
 KscKRM4cgkXhuVFQvZkDfOKtfT2HydD0W.HGDeJItQHwJ6acfgtn6FoSjHrculaljwLjIh86wVzC
 9IzgX69_W4iNN6WUddoouKfey2Qt4INMpJ.L96xi6CLdQRJOnlq_vTST7jtzTxmfUyLohzUeKCGT
 RWEKKf3VnJ0nIz58PWtqJ_szQWV8.YnCmf_Kn3wMC_ujLWew7KcyzhYH1GUKr6MNI1eeCXYPZLZL
 woMCIB8HVxGUtYDTo0FTuQ.O3fUBwZkM1I077XT5CfChonGIXxLmcoYrQalyr6QDLvd7bPnBwoBN
 E4JhA5m1FMZu1DE9dObFr7OufseVf7sr0I5uIs91Lm1WAtWnzMi1Gjv7XHFPowJWclEF4DGzXhtc
 zk0PlJucL7ejvtaX4MKL8YWO2o_3di6JewHUTdCOFogGHM4x9KjBbEImbJe2PBUYO2_Xy8SW3ymc
 nUw8GKUv7grf5YOouRnjWaNALCW5S2QHvuI3rpVGW1hSBkECxvi36KiR8g96nGv9oFwU6Na.xxF8
 JyCPAASkmzSVwTC7JeRNHiBMuYTfj2h42kSs9RnQiLRg43Y9XkJk0RLWhJPVtJHcTbuyYd56iLIW
 C5DHSr2syKp6au6KtqfJy06BzImjglNTfkr_EjwmvM1A0r9Rn6kOXAMLLd95LofEDhxu4EjKtoq4
 qNknZBBGl1ejLvphEfdCboJIyUEOx1YNaaqCLQP61IRco4fdBEt0Y8ArqR15ngg8grJ_oiCnHfX9
 rmGdYoCbo8f0udm_UYQrlULcZwu_zRC0bSNe2wxTOC5ElrClY.OU9Tqs3Z0ZNnupR.V0zAjh7VEN
 6y.0oN70jiqqHKZx6bRZTnMKc.._1KAJCBZpUuAuQjuWgZQ9qoANmbE1g7n6P_1hlCRok4ysDAmC
 BxnyLhYqT3GsUPMFSFDr4oTAuhGvOFRLjrnI5GuRiWPIXG8452n0E0zA6sg6vSseqxWI9Wv2p0l8
 orqwU9IhbBRBcF0OWw455RENpodhyoNXFMqUtg8R0FNiJx9dICJWMslp9nnfcvXYsqFZd8eB3fAB
 8.aw1fqEMDFwHDlDlKvla4qVtcC6ejN2CYz4jULdxcUtdiCQKrCPBt06tz.zFcfiFxNqzWWshCXs
 D1K3v0WMHIkA2fBQZWAer.f.FeH1RH7ZUaJN1e93bIJt8KrVyFCtQ1_dECkdZjqBcERqW5WgO.T9
 U5teyRe_aU_YhNqZo9IxA8r.NiQBQ9_cbvzJsVh.7wor986M6SbC_BHPe.jRV1SSbxm04IyMIAA-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Thu, 6 Feb 2020 12:05:46 +0000
Date:   Thu, 6 Feb 2020 12:05:43 +0000 (UTC)
From:   Linda cbally <lindacbally@aol.com>
Reply-To: lindacbally@aol.com
Message-ID: <364291158.163050.1580990743514@mail.yahoo.com>
Subject: My Dear
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <364291158.163050.1580990743514.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15185 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



My Dear

With warm heart, I offer my friendship and greetings, I hope this message meet you in good time. However, Mine names are Ms. Linda Ibrahim Coulibaly. I am 24 years old female. I have sent you mail twice but you never replied any of them. I humbly ask that you reply this message, to enable me disclose the reason while I have been trying to reach out to you. I do apologize for infringing on your privacy.

greetings Linda IbrahimCoulibaly

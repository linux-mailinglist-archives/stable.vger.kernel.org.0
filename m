Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C371122E99A
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 11:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgG0Jye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 05:54:34 -0400
Received: from sonic310-23.consmr.mail.ne1.yahoo.com ([66.163.186.204]:36999
        "EHLO sonic310-23.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727813AbgG0Jye (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 05:54:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595843673; bh=V09D8a1N75lUFkJxVR9aVpVPFU2IfPbM8afoyzXI9EQ=; h=Date:From:Reply-To:Subject:References:From:Subject; b=fKBfIOCDpSOecUjnKZ65n+q2JpUxG83QuqgwxwD8n3fvX7tFAnmBC7ABIcK5W9nc8NgoMZMzJwUS4JMlx8Yz/G408omog/GZGsjpvlQT2exHk0LXv6Slriz5BJTPCQskYoeXHWmcfaOBzcRjQqajIUIlBLHBorPwm/VUtP3PrrQS9obBsqxcZ1jIm+NEvJg/5EiI5qNNK8OWNTyA7N5j1sq1WaaFCKzPUZVUQUuAVhOWicWuzju78ykVhkujmDeOIPrE9gtfVhxE+7k0I1lOJWiCZnZrDQrhu6hN81RdEfFLADNOVtcddXPpsjT/a5i0xLZa3lqrOjG6OTfTknyYBw==
X-YMail-OSG: vI0Aqn0VM1mbp7VY5YPBhO3KMW_7zB9vRQ04iiQs9OfwizrJa8F1vMpNrX4T.zR
 NmSjtzJ8K7uiMeH6yY3rhTq7zmyFfKmA56Cy71ui6zV6r9nYyZg9PV0eXPBbGoY1c1ljFeUb.cJb
 ylQbW3Pnl4kM0cxlcRRWcdJ4DgS4LRWoqHvq35mfIePnRE1Hd4e_JJdUjCaQB7U_yDoXYOKWWEvQ
 ghVMe2wkh7iHZi5hw.0fF2iDyZAcDCFFwPrv3RlcaqZfn9kxhtgrylImINBVJ1ZNCrg2LTiY0.bZ
 v9ZSLs1k9rKTA4yaYTdHXdzxD4pYNblWhwtlKkjGUfK39.jybL3gfoGD.kP3hdcYpjWIJVQ_ywoi
 wQGyP3QUXpvMqwoA8DJINY0x.VM0koj5f5WoijbugrsWCFvDYaY0u0zByz.kirudjLLWJ3zC2K5W
 AugLjyHRoJakvgJzAT2RX8886ViaVS2PHlSTDILf77Z05.kB2R7Tt1cWNCH9_Mg58nnxX..6zIU7
 9qdqvyyLm8js7XULAMod1Tbvra.kmUNAhDIIxgaBugwjEBqkX0c2yBpPjBnjZcnTRSs_qlsuk75C
 QXFH4tRTBDDCKcBZkOqgHE3EqMFoc9O__A6tN02cTsBTR5JOk4..SkS4i.Nq9cMNuVypzbmNaCnY
 9x6HuDZQ8o5Ws9Yd4nyqA6oqrn0WPkn96.7rQy58VVHkiUS.1mfz9o0dOeNAqLiK0AUHfZ6oU30F
 QLiyTSVWZOnFmCzb2EzZ2xmxm5vPA_2qM_wplas3e8.UqM1X9jWTJQljotLnJ_CcpRR176RIPVhk
 .Mtdfmk10DrE_kLGM4xWkHfvbKUBwSSEzEnUKUk01WwEQWidLWmbH3STyrGbuZIUdYM.63PtvJgD
 tvGfg7cW_ISkuP6gNYtAVGc2RYX1vm5dlF7auTuiLMKQGMTEkYr7qo4p62NrCseD4Ry4q4gzvD2m
 WGMNvscYjkm8TvxspdABpCCHgPsO3Pt1aOeb1.kXBZh3HnHcs7.BWdJPGrCZovN7zTXbopT75N3p
 36dzeZtpaZ45t3SrZUf45gfj8CqI_cWKWf0caIhupR6SwBx8saRomh1TN6Lo2QZcU4WAqanQwV8M
 qFRqTP0yQJaUPBHKpjOkYGEwb5HLmu7n.rIMniYJP8OSExKMXf5HXE87S3POCfVcUVV2WPE5t95d
 N5DLpALP9Fel30nppH2Fm0jaZM1.2ftgMO._vdaVu8ZaN_lKarKhk1ibQ012e95jzBxFpPca_dhn
 iepsy3UWPtQHdTd70Rimf_oxctkfERhW.45kB4yyIDsjCv1IO5Wtk3.b8URrWU4NaYwOKaaMJXw-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Mon, 27 Jul 2020 09:54:33 +0000
Date:   Mon, 27 Jul 2020 09:54:32 +0000 (UTC)
From:   Ahmed <mrahmedoue@gmail.com>
Reply-To: ouedraogoahmed@outlook.com
Message-ID: <496677502.7604989.1595843672866@mail.yahoo.com>
Subject: HELLO .
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <496677502.7604989.1595843672866.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:74.0) Gecko/20100101 Firefox/74.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I know that this mail will come to you as a surprise as we have never met before, but need not to worry as I am contacting you independently of my investigation and no one is informed of this communication. I need your urgent assistance in transferring the sum of $11.3million immediately to your private account.The money has been here in our Bank lying dormant for years now without anybody coming for the claim of it.

I want to release the money to you as the relative to our deceased customer (the account owner) who died a long with his supposed Next Of Kin since 16th October 2005. The Banking laws here does not allow such money to stay more than 15 years, because the money will be recalled to the Bank treasury account as unclaimed fund.

By indicating your interest I will send you the full details on how the business will be executed.

Please respond urgently and delete if you are not interested.

Best Regards,
Ahmed Ouedraogo.

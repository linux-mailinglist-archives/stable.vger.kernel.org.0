Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C0CE23C9
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 22:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404663AbfJWUD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 16:03:59 -0400
Received: from sonic311-24.consmr.mail.ne1.yahoo.com ([66.163.188.205]:37513
        "EHLO sonic311-24.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405421AbfJWUD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 16:03:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1571861037; bh=tnR598H/QqPT1Ph/+p7nVdpgic7bknwMcbeRQcbc5RI=; h=Date:From:Reply-To:Subject:From:Subject; b=Puxzq/nZPFSmpojFwFscHYgTRKFeprLsFY2pDxSSQioRCDikSP/9vvDQddhyos7cachAn1WGWIQT3BSNrKNS1WR8mu66sY+OuPPA6uVfskVtsdFZIN0stPYQePWAlRiG/l+mN3kwhgvoRRkq+QS1yq3AY7HuBnSwCDdszSiQcm792IjD/czJSACaFZi4mrjy94fTjHHphzCmFK/Atjl4KEcxftGEHl4CcP8X2Kla4Ba8CDf3e0sK3Exb1BO3I0lK/Z6/hbzorMb5b8XQjti+k0P/0oVsz2/bwr2eV64B2ELlj2Qhp1mInRbmm8BxTM0j+lX2If1mgjmhb53L+whZvg==
X-YMail-OSG: 4s0_XqEVM1m7N59cKJNW1tyjxNAnobPiwMrjOi78K7bOwziXuQ.7wnHyJBzRNFv
 vVG0eogcL.bRBzPjj_9R7IB1Cu7hBJtvANy4ycAqRG.IhvBGJi2kKbDdtqPMjunvYFxjonwnw2cg
 pv1zEK59dXjdiKFReWFKTV3CAYN3tGBBUILXZtYIaFSGvRspeD1ZoXENP_aFTEvvzqq4keQJfMMp
 gP0B_oLMpmMuWUepHCRWi4Jm69vY1n7KvT6z71nh7XCRy4qgnbYyZ3KYddOnifpVM4sWZCjfUPIB
 YH0d0BdCC9tYqO2ek.eCIEr8WZ5Jb_POatQW6wTkbPB93JpQz7Fs8DoRjw3FM9klY6obK50Gar60
 AZ2PevbQa61H.A2b6zrmMP4VHW3yjnBUO_yxdfBecMYWizpy4jbkcomEZQNywe4Ltf30c0_SxN.d
 nzbFHN8gnmwx1PyYB_ysZ9Uivw6M5lkQzD17WIoewcIKurgHUexW9wi062azJ8he5DuVm1biCqVw
 v0CtUNayBQFwegY7k0JmrltSSuwdqUfbmO1hw4iyHLrsX5MuVJhQZ94ZvWvoOf5SNBMvsAw6ZKne
 F1r8cLBS0TTpElV7jDx_PwBjh1SSyAZUUgL.LcS6M6u37GCjEoJM0C1GiVk.TDHgENoenFC9b7oR
 FWj1.FMYj6RGBUcfT26GE7cIgFIndRBUgBUUAWmoCcdd3c0DcJFamCym7oRe1wUEqxr7cihVflxq
 LTz9N0gmb_hCI1_2L6zEINjW2_UwAAOtLUuCZvs8Il8nOutZhpwPZu1bKTEdMfAGbifE7iOjngYH
 jeHS8gWp8.i_fgnKH4b2Yp0S_NlSKNIlGRv5JUfJjSri7sku.MVx_B9UX.GbXNo9_3rzcDUU5xir
 KuXhQkInSTxyIjynXYkxfmqTNqxT6b3NhAOEzqgiYBXnKDd32L3hPR_GDJW8bR_oKU.znUeR2Do1
 h5gISFXEz.0fwrxxAXLUEj8z_kJVAsLhi4enjpFCsuAyXNwraP5bufsaDpefJvrmLXGOZYPEacB6
 m7t_y39TScDIvcWvVDZKe02HdMW0s4CCGc910s6wQPDxcI1v7lLNapE3i79fjj.qvS3rjTp_VE3G
 r7lSijWCRKeQNl6B4WGLPEsBfTVLKV_LYmEn8W20Sk_5f33Ju_RUq8Pm17Gwkjw62q2OIpvCIqkZ
 bJdTQkr_H_QD8dWdCyqpVZ56UlikYPzvir_vJFZ0p.1_DcLFFUBhNEA51UkwjTOVw00NKFSsKo.u
 KR.Sw9zJHgBufX_TZlIH84xHHVeF4C9jhoXUxUk0dZkhpsZG08auTfAlUpbPfLVCPAY2WGqI1Mhk
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Wed, 23 Oct 2019 20:03:57 +0000
Date:   Wed, 23 Oct 2019 20:03:55 +0000 (UTC)
From:   Mrs Elodie Antoine <elodieantoine890@gmail.com>
Reply-To: elodiem97@yahoo.com
Message-ID: <1992475543.1210248.1571861035769@mail.yahoo.com>
Subject: Greetings From Mrs Elodie,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings From Mrs Elodie,

Calvary Greetings in the name of the LORD Almighty and Our LORD JESUS CHRIST the giver of every good thing. Good day,i know this letter will definitely come to you as a huge surprise, but I implore you to take the time to go through it carefully as the decision you make will go off a long way to determine my future and continued existence. I am Mrs Elodie Antoine
aging widow of 59 years old suffering from long time illness. I have some funds I inherited from my late husband,

The sum of (US$4.5 Million Dollars) and I needed a very honest and God fearing who can withdraw this money then use the funds for Charity works. I WISH TO GIVE THIS FUNDS TO YOU FOR CHARITY WORKS. I found your email address from the internet after honest prayers to the LORD to bring me a helper and i decided to contact you if you may be willing and interested to handle these trust funds in good faith before anything happens to me.
I accept this decision because I do not have any child who will inherit this money after I die. I want your urgent reply to me so that I will give you the deposit receipt which the COMPANY issued to me as next of kin for immediate transfer of the money to your account in your country, to start the good work of God, I want you to use the 15/percent of the total amount to help yourself in doing the project.


I am desperately in keen need of assistance and I have summoned up courage to contact you for this task, you must not fail me and the millions of the poor people in our todays WORLD. This is no stolen money and there are no dangers involved,100% RISK FREE with full legal proof. Please if you would be able to use the funds for the Charity works kindly let me know immediately.I will appreciate your utmost confidentiality and trust in this matter to accomplish my heart desire, as I don't want anything that will jeopardize my last wish. I want you to take 15 percent of the total money for your personal use while 85% of the money will go to charity.I will appreciate your utmost confidentiality and trust in this matter to accomplish my heart desire, as I don't want anything that will jeopardize my last wish.


kindly respond for further details.


Thanks and God bless you,

Mrs Elodie Antoine

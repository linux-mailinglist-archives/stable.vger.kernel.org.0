Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773F128F126
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 13:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgJOL1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 07:27:35 -0400
Received: from sonic307-56.consmr.mail.ne1.yahoo.com ([66.163.190.31]:36410
        "EHLO sonic307-56.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729017AbgJOL1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 07:27:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602761244; bh=V09D8a1N75lUFkJxVR9aVpVPFU2IfPbM8afoyzXI9EQ=; h=Date:From:Reply-To:Subject:References:From:Subject; b=OURxZcsbRKShFVHJ8zTypc7fmG8NNZWBTe4cOh0cspnzQkD0IirrhWHM4Or1SkhjRKkAQ3AVTny1o8kYfXUwEzBkEWmItWQf9IOjNiTRON/nlmK0GIJHe2k9bKDLgqj+Kpb/lqrKJ2RaRs2D0cd7+8QvdZxMPLX/YezLV7Kna5DRoIwVwd9zV+vqaf3REJrHa94t9C2P0437B4ZQqhJ5wuyiUrdNrMSkk0jJVtt/In2OqOWNtYNbH6IvJBqlMeHeIFOZdExl31zDbvGiLj9N+D2/dkCuuxTx22VCyiqnPcRg1PsyK9QkOD16hNg/9amGDosk8N8n3fnsZ197G6j/CQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602761244; bh=7S2XZY2vcY+VQa+51r4+OLzVOBmJOaJ/CMh5P7MqA8M=; h=Date:From:Subject; b=rdPeNr1LTRtpGmhBzKpt6K2oGCBbximtouKiYZqoEo23NKueI5PYN4B/iUMShPCBIPhcFoXZaqIhyTZT28qr157z/PpcF6r0yLy+1vHCXxGpraB3vdZ2/7sup/SZL7vJOGdFkB2vo7SVD2ISbXbPfzfxfhybazoCNsTEaemKR3NUH7G0MEoEQPwm4d57/rs/JKh1FPAZ/Kl6Qn4o/AS6US6DOfDAtdf74x9JrkPIWuom8z+ckNkPGnHnLjU4RhulGcKIy9Ogw+LY/xKIemH+QMQmJYxxS/R7xqhpP2eqQXtTPqSlm2K7dF1m0NCLyLPBxXJp2IIiDFTGOeJoVHAESw==
X-YMail-OSG: VKybvekVM1lZnQS0Y1YhI3DwgxfszIRZTsoECuEU1Yxu.DVdmWnZ6TgPS0Q.2El
 5GyAB2D4P.knz375FBSPtBb1rzqPx7exo4h3SUYtYUTVM7OYoOW68EFLvCYAo2d2sOEv3eHix5I4
 4s5DJ543s8qjcZRo6247qCcl8GwhZqbbO4_G6sMchsT7F.Q3SMdqrusym2GLaYUvLf9F6_qEDBXe
 Hommjb5YwC.97IFb1p7CmXgcbO2MP32Czi.ei2e1Zo4V.lLuRRvJejwH7dbVZaW1kqINZY5JPCyh
 G.8pnoE6aD3vrS.N669accZkBydviL80JiCWXuSmDhMXeOD4xHc2RHaloFM5dmx4RasBZO16ziNb
 X5sw.wN_PAG7T5yCH0LLP98o4ePGMdvcdC9u7l5f4yUqEOEBgM4VbbZBlS318LZF.av7thS5BQnt
 P4CtcoEZcKSPH.Ctc3mJpztOA.xmbCCE5ALuOJi8hi7lk5cLBWsspgtR75LDQCot_g6TS._mJEPr
 kxPm3htfav780aOu9UEq6x6tzbYdnrcf27R42ljcYaAJqohsgp5YcaFflm98L9_jzDW_YW90_U7h
 9vMVgTNSdp3yUKj2jDy6ejMRINcVgaPch4hbWq1jpLoP5uSgXy8cZ.Ogd1JKudHpAyVCOAiY6lPO
 u8YeQBbHhWD6n0sgy3bMRM5hjuqOcxgdZWiscBbJEejkO_qSnwxC32UxDErW9dhzFEbEnjKHJ.Zm
 CpuokKtuRY8LgThVY9iQu3O4dlxMNYJPaQbgOcRMPT.pdUgZsYnEK9mf5fSggEJZUy2_Yslqz7jS
 JsnOZNFf.huUokecPN9HegWpjWFFoCj_5nJbhczjj15..CYmvxKzhREC1SUw6yHtx.X.5Md.Tc8w
 Y_Pj2C33h53Y4er.w_D9T_gGz7Cm_KRlc1Bdk2pMQKZSg8dEASNvBHKtdPWX.WZ.NFxqyHKz4JvE
 goUc5QpmQqhbbsvzu25pOUKBPespm.kXqz4_.QO70ZVxX.4VShfTjQbrUfUOu4F3znyASi.DLGiC
 DO7N8k3BoXIHcwVZp.wOHqA5RlBOm01F7p0fFsEZYqvcAyTJAUOxStJwI5FPtEqTVu.XpXrl5Aoh
 GQektawF4DrLIEXxizpvA7U3mi5zATxrlVrfH553f8G5kLBryvTS8RP55H8tRepH14FOU.NmlIep
 6VIXe7HgM2a23FQk1h7PrfqfNTQ1UBG_5CrY6uzw0D71mRqw.syQB8lhyYLCQ75sllqOPhxlSJSB
 IZJef5EwBGtEQRmYq7T1E7TQ5f6z4Ny7RQqSubFO5dL8jvzPJPwjCnnpKXPx5wp9VpmAYquC3H_i
 ZqQLuwg.onItaQidiZRj4H9IS2Odr9N9FfRlN4onhJQAyV78AjU6GVsstkaKia3EZgioHL3PqpRm
 zBohhMpzG1YC2BZzr2ASWeWWmftQIJKGM4ToPC1UJ8tM-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Thu, 15 Oct 2020 11:27:24 +0000
Date:   Thu, 15 Oct 2020 11:27:23 +0000 (UTC)
From:   Ahmed <mrahmedoue@gmail.com>
Reply-To: ouedraogoahmed@outlook.com
Message-ID: <1685569464.910559.1602761243608@mail.yahoo.com>
Subject: HELLO.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1685569464.910559.1602761243608.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16845 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:80.0) Gecko/20100101 Firefox/80.0
To:     unlisted-recipients:; (no To-header on input)
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

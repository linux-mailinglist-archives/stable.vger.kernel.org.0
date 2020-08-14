Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FF2244468
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 07:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgHNFAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 01:00:21 -0400
Received: from sonic306-1.consmr.mail.bf2.yahoo.com ([74.6.132.40]:41005 "EHLO
        sonic306-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgHNFAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Aug 2020 01:00:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1597381219; bh=Wbb5kU9+nuXHtr27nxpSCllVwLyRvN526jc5ol4mfd0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=qZrmjQbznCTlGJBwihKDOZHbdaTV8uT9bQt7y8YOi9yMni6EMMrDHcBxD0+T6V/HZTGbcEQpc67m82TQJ6h8S7oHSPIDIC1g1rvzD+HiDRJIMDdmnHJJa9gCsbde2JsDbnIIOXMV41MVWMbQ5fRkpmBESTLRK5JlV1eQ1JcP55kN7SmpnW66q/VTQSlE5h7EIteqEyCCGy2oZjO8xojNgC+qhG4QhpcKFQmJrRmxwVB/9p20ymbcF4Mr5L1T52owVkp56NTusznZtaKyebyIXmNEp6Au3zMHrcYQrmQWkxnTfC4NO6mRAIefwr7nSzk2xXkSkMG34eADJ1LZnx5GMw==
X-YMail-OSG: qNZImSoVM1kO2ZBGRMaYsYbbpEKFFILbaDxIJFSLIG_y2u9Ej7n7umdO2ovBZZ6
 if07JrvuSP2S5IF7f_G3QT7eEHqQqnjWc32Aek21AVF14aJbQCu7Ulg4FlxvkYJ687mbw7Fm54BF
 0_Bi4wCX2NRFr7gU2uoD6YYeXYfvyfwjAYvLy0MD.7QApyW9FizLTnfVt6qCAqD6BZrC_H5zAOdJ
 2DU0vVTceBygXTtuYSQ3K4Y1ZCFpk3vevrYJH4_vi35VpuzwOSZ89wRFw4RWJSiqJoSovVN2EABN
 EUhma3H1TI1xxJ66Br1gAAQwIHwCHLS8t9VDCjmXGYy_xBX.TPp4GYonqZQGyKDG_vwjOG9JrUNk
 ZHv_LkRDioqavMwOKy9O91vgsSBDRumuaZNTN4F7r1k0oxLf1qO1es_.o1SFlxDKPn0RCW_fwxf4
 1_MfhX.IVF_ULlAk2SqveartgjnfOuev_II.SghsEHh6bj.4_Xg13OMm9atsS5m0.LqVLHEEG.wL
 Nx_Zy5lyYMlkKZavsCCdktSgJOkAfJRXXXS1At9OBtCH4TyEGMEUBwxTodGkv7UocwM3obWiC8H_
 YGFyyD0TNOqaXyRUqj7zdGWtbQLPJrkKkZJ4Tf7DnA0lQeadEdmK40iYnwcrKySrQ4.zF8.92QsE
 oidyJJ1JpI8hS07DC7LTeHfj3efoXjfZMaHG660jiNzOQkWLwtU9QOE4k8u6uWcdmbvAkD.VegYn
 asgKHkAlBP5XET_b3GFOGfuE8CD9Xq1LVLG73NNMG6iWo_CTZmirXTovNAmQ1jtYwMDukblG.6bP
 uUoeF_dSTUE.PuoDSWelv2a8cJZpmrqmEZO9Y.0mphVoyRV0dkg79vDxvtEHTeoKyRrOtobbslPX
 EDF_EG7XbK.58TV3BSRdYZ7F2qOqdI1MqczMylqZBTWHmjJbDUa4YCSAOzwuqts7bAaPCpr98Lhi
 CByczJiw3reM.mlHSs1OyAwy6hERLScR7kCflyvTh.6BEjyEVakCvGUp9qgqCkenFJ9Eb54P6SpP
 Hn4.Sbx1WjqZwcTHwKADW79IQnRH54TER.dcNwYgPEiBD0zW.By5C232zmmPDm8g9KVwCGgCkEnK
 pUtHF3iPHxZXR_IZ9LTvlaz12E9SsY2EiI.zvE_03yDLY7ASJLbu69P_mCfwxUxuXjvt45PsJzYS
 IM4TPUQGcfJvROa7QV4z1ysPvU1HcmVgT84neUGltiorufehXxSpJQTKZVH6g0RNrFjHXsbRW6UQ
 505706A9PxB7aqLuL2V8NsATiLNsjgU9n746GTYG5x1EgDoj..FthfJEF7FIc962gtR5kZG9fG0l
 2ahmg9BNPSfCQpXKXHiK3YVWJkWgfgVEmnHkvXKS1d6MGyVCRJzX_swnx
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Fri, 14 Aug 2020 05:00:19 +0000
Date:   Fri, 14 Aug 2020 05:00:18 +0000 (UTC)
From:   "Mr.Sawadogo Michel" <sawadogomichel38@gmail.com>
Reply-To: mr.sawadogomichel1@gmail.com
Message-ID: <402479655.1394420.1597381218427@mail.yahoo.com>
Subject: Hello Dear Friend,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <402479655.1394420.1597381218427.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 5.1; rv:52.0) Gecko/20100101 Firefox/52.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear Friend,

My name is Mr.Sawadogo Michel. I have decided to seek a confidential co-operation  with you in the execution of the deal described here-under for our both  mutual benefit and I hope you will keep it a top secret because of the nature  of the transaction, During the course of our bank year auditing, I discovered  an unclaimed/abandoned fund, sum total of {US$19.3 Million United State  Dollars} in the bank account that belongs to a Saudi Arabia businessman Who unfortunately lost his life and entire family in a Motor Accident.

Now our bank has been waiting for any of the relatives to come-up for the claim but nobody has done that. I personally has been unsuccessful in locating any of the relatives, now, I sincerely seek your consent to present you as the next of kin / Will Beneficiary to the deceased so that the proceeds of this account valued at {US$19.3 Million United State Dollars} can be paid to you, which we will share in these percentages ratio, 60% to me and 40% to you. All I request is your utmost sincere co-operation; trust and maximum confidentiality to achieve this project successfully. I have carefully mapped out the moralities for execution of this transaction under a legitimate arrangement to protect you from any breach of the law both in your country and here in Burkina Faso when the fund is being transferred to your bank account.

I will have to provide all the relevant document that will be requested to indicate that you are the rightful beneficiary of this legacy and our bank will release the fund to you without any further delay, upon your consideration and acceptance of this offer, please send me the following information as stated below so we can proceed and get this fund transferred to your designated bank account immediately.

-Your Full Name:
-Your Contact Address:
-Your direct Mobile telephone Number:
-Your Date of Birth:
-Your occupation:

I await your swift response and re-assurance.

Best regards,
Mr.Sawadogo Michel.

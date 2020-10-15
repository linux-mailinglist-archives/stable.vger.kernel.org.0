Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC1928F3A1
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 15:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgJONu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 09:50:28 -0400
Received: from sonic302-21.consmr.mail.ne1.yahoo.com ([66.163.186.147]:39397
        "EHLO sonic302-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729647AbgJONu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 09:50:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602769827; bh=NajTNMrfMLb6UXcjRhYpYerQX8PtVBLz0oFgaMINSWY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=jVnvkMOM/CAqbQ+qoobYhPhWdU2nhEoJPhpU3s8BjLLBSoONR6QHlerPbvAmTfiz6dSDKewcnMGnr6u2txAsQGDJ0GPB3LvnrV9HkeZYC3keOS6gGOUpoU9/fqOihStEKlv6wLitHmq3CDbDtr6MOamBPYBQjaeJKvpLcD+zaVPsaUmrAziJoEcY0Q66BEA6mbVt6ji/QG08nhvXZrKVSHBeOGpC/OSSgdsYmq7FnjuEsl7xB6cfv/ICZ//Ipamh77PSHEmq4YWLraGcCuSrhvRk/gDSho+C72eFpjD2GDQEpffpf00jhuwrm+L3aM2+4R6Mc9+i/Ww9i953X+4qrg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602769827; bh=cKvCU/Rgkye54Hq1f7ht3bl4MwpwafqA32PrXChTUxM=; h=Date:From:Subject; b=E8FBRbZtaY4hPayM+SeMHT2iIA4T4wDZPNy67N31jhhvo3SuVQg4VbrvDQc0OXlLDPu0RdwwC47QVv0ZvFPMIhXN7uFq+KXTQPGQuxtKZP3DRQxkhE0B18OsWF31PYUahg5WVShRBOly3jU7unfsc+bO99YTPbFZMjyVh0+jJDsqAJCkSyjz65BDzW2rm/mXc/josH160ILViab01O2cyRMIRyZbwISpnl3l73Wy4g079ZT0tWr0vrbuk8wtARxT24u+8GXH596LK40ge5HlhTXVa0MiccCFP3LQe/HUgto3eUBZvAU1JqaOA8nPmoPpfB7baJ9JaV+8/csTNP9Egg==
X-YMail-OSG: HMz88SoVM1myPG4dG.FlzVQ2uU.mk9WVP_h7uN5FCrxslA8O0qa69_79e1KlwzP
 qU9BYm74zkNgxtQDOFvJxSjpKTJNBFT9nBEWfDz51_AMQUWFNYyZK4QoUUCzeT6o1Bzd_r03d8zk
 d_ZxMfAGHWN2RMtszrVLG4UYv.ZyTlAp567MpylKwmGmqTtbQ0jZ7MAr4gTGFjT1NDOi8Vg4okOW
 XsT5hiYL8cHp6q1NnNGd6mhXJRTlUAFP7TSy0UfVut9USJy7ifYsRoelj0ZPCqdDGZRRHVy170ZP
 jWfF4lQoV5AMNPz8Rrm3msxyEMAO_x710CWNOAlbe.8kdJxEwu_q0V0kRxuBnt_1Gp3JnWEREOiB
 gKre_OYH2FXkXuXxEPw_zOzulcbfAu2JAmRz1vjw8qWybl7EJeUGXUFDwVUs41gQzLIPwIqHOfXF
 _SCH2BtHgysWjvMFHLicdK8Xg9p94blBoXVUqhtbY9BlL.RGBitjWJr5FWKVHOlce0wP5av2Zenn
 9pnLe3vJtRGip.W0JJFLpTT6S6Q22IhDLr3epMUqzUr9RzFyCbEI1RQA5_YQ.RRtDMlh45YST.VZ
 .QNIcXgKWdjYckSMrrS751acCkDxKMPGuYw_p6Uo2GeXL3NxT0RYSvq3lb6NncQzzQ7Zu3LJoZR8
 VApBVHGsiOyCfoebju2A0mlT239Rox7pVcY4M4ixxTJhm_bzu3AwQaJQ34eH0M6mMMbPEh0nv7Z5
 3.SmuQj667aWXEH_8oi_azg3PX1FPjxO9wL9pqCvonbD6DTeePzv.F_lwIUefA_WnRENhzdyLhUy
 O8gnhkg._Kgm75h95UOo5wm0kAdIc1TtNgB6DBs8Ak9FKxT80h4f6vgTyDG_FZ8O6deMOrX8NU1D
 U7YxJoydpgIQ1gNSThJesXjjtxL3gGSCngAevilQGNp5OJt7asA8Jpek.GgbatzIpB7tY5yDg0S1
 fjYQ8mzV3cXs4jqaNjFH.FwM7I4yuwGrsY2aCrGwQnePZhdrGbHaR.xoyVf52YTB6rjnEMwr2e2D
 kcI1hCjIjLFNZXIsC_zNsbK7KNVkyN2AEe6kKu9TT99Icysk7oMIr4S06iAKFW.ou9VR0VUCCfvK
 LXvd8LfsRal80YyMVvHbOm6hr2mB_EM5LhhpsYxjwCPXEbgiUbwqbH92v7fGm2CsxOAVRJ5bgtDw
 heV5ZOsHv2NROWkCIG.QscIlAP5DVJsPHJrFLpjI8DuEMaZLoXVHN7K6xp2lZ3lQWEIGddnkjNZI
 AThQ_hwDAeZYKukCz.w3101wBlGWcwKbd8EvrCu6gM.wF64M5t46BbRLx8P2BWo5gClMOjx9wFLC
 hz01MMBUPnXlujeUyUUaUvMze5junM_yhxuLNdMEUg3cYuf5DYItVg8YK4hYQ5nMqi6W8UIWNndC
 3T1WFzBH5UNff7Hbkz3U3KyFd1PDlAo2lqjkhhWannji.KUo-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Thu, 15 Oct 2020 13:50:27 +0000
Date:   Thu, 15 Oct 2020 13:50:24 +0000 (UTC)
From:   Ms lisa Hugh <lisahugh531@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <655405363.956170.1602769824756@mail.yahoo.com>
Subject: YOUR CO-OPERATION FROM (Ms Lisa Hugh).
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <655405363.956170.1602769824756.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16845 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I am Ms Lisa hugh, work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment, amount (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me for success.

Note/ 50% for you why 50% for me after success of the transfer to your bank account.

Below information is what i need from you so will can be reaching each other

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa hugh.

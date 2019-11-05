Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE67EF74A
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 09:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbfKEI3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 03:29:49 -0500
Received: from sonic316-13.consmr.mail.bf2.yahoo.com ([74.6.130.123]:44453
        "EHLO sonic316-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387920AbfKEI3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 03:29:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1572942587; bh=vdONypa+pmkSCxMpJ481zxWsfmYXdIIKq3bhYsM38cE=; h=Date:From:Reply-To:Subject:From:Subject; b=nGC2QoNHJJMPr8TYqORLp6du3lokbhNu4rziSeG37KQPQ84pt2FJeOSx4J4z75odsmS9oq26B82tvbXjckcy+wLiwsCeqbHrBE4o9tTq81u0GJTD1gJGTMC9WgItp4JExVEL5bt6eDcVQH0Emew+Fzg02Ww9oT06sihN3eFTk/6iBdtIEOavlzAHE9J3YxgEUtmhsrKJasO1wBcwlB4SAUS/dDiNijbOtHUdLTkUEe2owkxpo2zx/yCvyWq9naAdU0wVmy1TXNZQE0AmACAKGVwvPxzJUXH8eYhp2Gd/SI4auyrX05zkZDu6JIpw4SUl3H2Mi7akK9kqPeSPsObYaw==
X-YMail-OSG: wNHP4CIVM1m4QDt0zNU0czcM6zjrygRyBx2DEZdyKl1QnbJAOLiP2xEiTJBv8wk
 xnI.19tXIeT7ah0_7499jyQU0PT7AIOVqcEQEkLXjm_QrPh0BTtgy6ZlN0noZ2YPXvKL81stPUzt
 ZKEcBjkk9FsYE4O6Jq67yQ85eT7aC_AfeH7NjoGAVr7ug7Tt86ptV8SjkLcm6XfuWMfPy82s8DD4
 J3me5hN3uCcWUo7Ou.WDpVf53PIATadCXJ5n8yiIKsqqK_7dZEBNj6VU.JMUDbOe_wsk8xRXnrqp
 1GOr8v6WXDd3aJJPmo9gwJjTC4FZwn5NKAG14hh6anAzEl2eA7LYArVFeYOkR4GyrMqOg4Ng6VJg
 CsX.D3TfOjM.QvVXi7rtYkZwv7PjtoPxNCRzNRBoI.dekXizB.4wxsjp_XPqEsyDtxz8ktQ2PTGA
 AwWo4nNpzndTzbBsn_qex77q_KylQKRj8sa.yUZX6T1YOnIxQyr0yRG5bIG1pyJ702r_SY7gldng
 PIR2eluPqbnhvCCK4Y2fpSOrxgnUhv7eWWSQSgbiYfOr2u7944vKHS94rfCdPiQlA3LGRGzXgBC8
 gZNahjSm6RJWsmLw4sXo8YuX_vL4WHhe7gQPYtYVAj7c_RPDCbVAD65q_Yq5zQnk7rLc6cttAPoJ
 1pv3GXv6rYn3BZRgNMd.6_vuwiglfTWdcfd99UWvymHTzDm7OvJz8jTgJ1oL8IF_nSe.gV2YBdXT
 EtPmsByp37TQPBdbKgGPIWMSI_wny4yzE_nzauqHs9k_fIL9WeyZPoBbPzdYPj.SVedO1WEjoFdZ
 U1AeIgjLoTRNhxORfka9vGBCQ9jhRJdpc..hvkLr0zT.LMMEt_Yf_O23j8DZcBxURSqEJZyC5Oem
 Bw26d2pwd.IPJpDNDjRjjW57eUztzQd2o6CdQbVRr0EifQWCTU3Y1TTdoZrfNlgkTe7Wkww6ngVC
 Vgn4ICRX.4ROPJ5xIZV0Bh_KR9OHLtUn4LNrkGF_beQYvD70Meg_bvm5E2HusndNO0_ymWFCv7Rq
 48t4NIHoztAUlb0U2184r7hU6jr2itSpa55S3XMA1AXcQekJQBSs3iAmIbr8mG9mNj2IOnGOV4Of
 o9CbClpkppPnPVZUs_htgOzcUFT3Um6XcrOfc4EY.3HWOr55p.gg.yk4KDM0K5OxLAHqPwtvFd8V
 drfwT._WJTbEho70px7S.y0bpc7xP7KUtbAFbszT9mReDf1pmZ0q4Be5pclHRFZ2J5EtpxqZlZ0y
 IsFVyBpKV5JCrXZ3UVDv4cqKIkTgtSF81UlLA0Arc.cao0ONraIUBR4yL27NpTF51Wmz3iWuw2RX
 n_mRPbVf8Tw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.bf2.yahoo.com with HTTP; Tue, 5 Nov 2019 08:29:47 +0000
Date:   Tue, 5 Nov 2019 08:29:46 +0000 (UTC)
From:   Mrs Elodie Antoine <elodieantoine423@gmail.com>
Reply-To: elodiem97@yahoo.com
Message-ID: <1773518564.855615.1572942586578@mail.yahoo.com>
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

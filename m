Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157F6295185
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 19:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503492AbgJURaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 13:30:02 -0400
Received: from sonic311-31.consmr.mail.ir2.yahoo.com ([77.238.176.163]:44476
        "EHLO sonic311-31.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503481AbgJURaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 13:30:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603301400; bh=q1C/9Mh7Qw9wbzPZZVYs9UsLDFdW7TfJAw0vMVR5QHs=; h=Date:From:Reply-To:Subject:References:From:Subject; b=lt/kSt/dcf7W7nKbwZBwDfad8vkpLFpofYzmBNuKXG7y4zsBLPtlfyTyIkHda3ch4501fvwi7FW5Y+Eq8Y6r8vZx9nsWbgt6oisVQBsgz5UU1/ramwh4UhDUNllVb5Y59TGqjx7SC7n/0FtWy2hml5yj88y+mdiqalm3sL8o01Td9ZD8cuZ+gPSOR3aKVueFl2RYf/FfXikWFmwwiszRTlOzSrdNuKkvcEFyUlwnROsfCtOc3gsLm4OXU2j6pFfDFC9RI9nAAd+pLwuKobFFYa7oQuTFIFv6lMC4oM2+fj1TIfLQJzH3BIa4zpH/N4HClscOgkLCX+7jp+YcTNpOQg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603301400; bh=YnqCv6RBqqZpyJtjI8ycix4+5NCpUN+O9lkfvBpZoN5=; h=Date:From:Subject; b=a0lMIv9Pul8hQeXDBn2rYT5NP4jAk/8e5TgqlYq78QLNPPWWMGJuEvJQyTG07SXS9EWp4+zYsu6QlE7ESpc/0xWEiHfkktbWP45Bxy/7pt26SISnDbn8AC+XdoKiuHHww7LI2YWHRjs4qsqX+ooXlyOTFpbYniOn9QRKunQqZ61hKVC0wUeQwQiuEoyOMBu0O5nxRdRdsnNlwJqryMbi3awOx2KyxKyClBa6f/hEzo62VwqBnTxA2fWyyNU3nUm4jTUGCTU4xy+QS9swjkFI+s2CpyqHzQyFpOALqc7K1bk7T+iEsKg9UgHS4tHLejDYMRLhxyPNVgLh2yNz6i0pwg==
X-YMail-OSG: NQlzhS4VM1kc6DsZ6v9UvnkuPbPSbJBu.l7yc63PjkPI8J0nohYB7JrJ66IKIyi
 C4mSvHeGrki5b7lK_d2_s9uMZlQVgOxlDA_xGAxjdYUNsSIXqRyKkdQncGbAAurH96qabbXWi8ft
 ePrBJuE6gdhMI1kfk9VeKzUHsKQTQBjRBLcDpietk0QQ1IkZP0GNsMLYK1qhT0b7B4F7MUv.SyhM
 1u8_VAGJ3R5q7WcKyjntQYEbCuwnyk9dIaqhvCQ7MmwASVmNDZ4n84IkD0B.E8SV_OJFV5eVTY36
 Wu4aV0nXUM2pTfWcb3Na_qrDXlNHIkeOEp2mZKHvc6kXaPUfqPCUihKq5Vr4r5.hfmvkffTI0yVv
 7OgnKabaKyt3ywl8VVew_V4_R6mtcHcW.JD94zGv3cRvxUeFLuV6sNAbTFIcNoyhcBG.SFrM_Nw9
 CIeNM4gb.K8VVQcxYnok67SForcon1sq7EkOn0LniiON4xXn_tJXTg3kqEOE5Zuxf_qs6ukm2vPF
 jLL5PVGqjb9gx3pS.MIT3v0He2cWz8zwBscn4TMd1iK_9_0UhS7Foy2ZBXCBsHjJa85rMDjml8ZE
 81BKkXdyU_16sn8Ima_hYVFXQ49OSlr.Nccxt6Xcp_y8mxVZ01hug0X_cqmJm5wGigDGCElIX4pU
 d9MNyEXMTiCjOyMpNIR.5F0yjdfVbfPyy6b5PnegwNtPM5vdf69zAtzRSQKN1aq7HQF5HO1X3_S8
 WKYcKOzDcZ3PIi94WfmNEuOEOtL9pzZzsyeAmSnkdpcfl9eVHvrwQ0DRfSB7bxkPpefL.NQ.7pKI
 RtoV6Uq5NzmVffVvz5lpUgIgO_1vFkuVu6nX9mEYCeR80lmWrkT8aGrH9fn3uDzhDS4GHlZCNiVI
 P4N74aI5kLUsfUh_u3PjXU88tQQal4Zri.ezKKiAv3dcL.LMBwJ7fWuNFJvjFxO0CggZTL3zWBhi
 L6CnDyo4yX9ojwpfRPqbdMZzlvOG6ANp7qmsadw8Xj3WlBRYv_ercMXWAgs1VzaTzH8Ih1YYf3kH
 6p0OFR28FUCBcCpWnYXARtH6W8XgaqHNkFgheDhsWUTJu6q_lA2Z_qW_6ut8ZjvV3Gio7BMyqC6S
 YRqA1Q6uI.56Njivdq9RRQfF3NB9A3dVT4coMTENBKH35tzGdeATq2zfZIZgj0_feV3BoHKiTXDS
 mr.Iaf.hkcEIbdzQdlJvN6h_2cJd4xUUoljrSsh3D8TvDnAfd0sUVyi.4NF1Rb8aJOEJgmLdSZe8
 7YpB6m3jHKuTCBSxNbZBFFYQON46uOUbqbAo9WzqJRkLEEiy3vZbCypNcc58EAxZZw2BQEfS3bzv
 ABNQkN2sb89Q1Q6ylxxU_dc.tcUDFOQuvjjnRCLnOKdZZi5xCLtedtQI9YUBP17OVhy3oFSWhpZR
 yFMwhyeBSsvvwmJtUphxdXZFZcb9k0IM3PJNo3i_CKGAuBMnGog--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ir2.yahoo.com with HTTP; Wed, 21 Oct 2020 17:30:00 +0000
Date:   Wed, 21 Oct 2020 17:29:58 +0000 (UTC)
From:   Miss Favour <krnbviodx@gmail.com>
Reply-To: miss.favour150@yahoo.com
Message-ID: <457549217.3142446.1603301398761@mail.yahoo.com>
Subject: OK
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <457549217.3142446.1603301398761.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16868 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,
I came across your email address through the google sites and I have much feelings over it. Apologies for my surprising email to you. Penpal friendship doesn't think distance,age or color. Friendship is hearing each other voice from the heart. A friend is a gift from God and someone who cares as much as you do. I'm Miss Favour, I want to be your friend. I'll be glad to read from you and I will reply with my picture as we get to know better.
Best regards
Miss Favour.

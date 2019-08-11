Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA7E989141
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 12:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfHKK2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 06:28:08 -0400
Received: from sonic314-13.consmr.mail.bf2.yahoo.com ([74.6.132.123]:38535
        "EHLO sonic314-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbfHKK2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 06:28:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1565519287; bh=4hCptOL7w+OzWiWl6Q0YBf1mqxZNu9dVzHPRhoubvrk=; h=Date:From:Reply-To:Subject:From:Subject; b=PPC9y5IKJPDGZAWMG6sbtJq/7C1B07GgDYkq4qYrd8QNvGefdibrrj9U28NaKSWB9osuo/v0BwY+2sE9x/QkyBvLRgk1MSgOZkb9BIzNozVsJ0Df478rKww8OBOaFX+gNAoqYAuPPx+NxSRm5bTFpTHblmn32qo/xYBNnZMCCb8RZP983OOb9SwJs7G26aftWfPcOVtXhfowlcC9VHvjL82PXmRgKMYebtSpUN23wH/LLxJzE2piQl+Mrqcd0dOn2TE3Qk9O74pYt9necW9AWxwcniQa34kIYFxFVmBozg88ogr3RLy+RPxh6Fu+3FVwMQGRWGbtXJTaK5jYDjXIVA==
X-YMail-OSG: _sS6rHYVM1nwVIG1uNJIk5m1vLVgF0DET2wR6X8ZHMqEniZk3JnHwjRdc2un1SX
 mmw0aKCrbMJwPV6HnyJU6MMRR5YprbywsDnP_kub.xIEkPz2IfXT1L.cmjsDDZfsg.MF9_jLZUH.
 bG0gXfJ8TTsUghJh5uqGzYss0cJzrPSF8lH1rbfzp4fL..7j.wT2e_SOBiflMYzb_ATuDrN2HeOn
 9l4mdxNBW4crqoOTGU0Aub101onQrmBjI55vHar9jDPD4DVx7XSTC2hH8YmyXc1oBuJEoFjXm0sD
 1Va2Df3iAaIV6fob8pCp7UOBsQnj9SmQltIxnIQ9HZeO8D.YFUvfMzqO6jOK7IomA.aE8j2W9GqH
 vP.Cih1QQAqi6nORcwRHDQK4C3p1nxf2qHgrmyFsfLegwr58CkA9gsZMETrpEkqJpH8CNFeEsUNl
 24hO.vPfFWTYZbekViEHLndJip_YJmmg..hClxulMnKF8rI0CX.ZKPVsxMXNy3ut64p3vnRCFErM
 PzSo9eiMCMs7PlCXFCrdy7B7ljPfmSX4Zd36yCVMLRsEBcrGrfnaXQSjCXPBIKF7L1078zaXBaMV
 FNjStvQOUlab7lJkfq7ME1.8DdkjB_Aoz3jvSVYCtL7667VS5e9cwzw9JxiMAw8qiDTa.W5WbJgl
 EK0GKNYfBIStVbvBeDJY32PyJVWabae21J3O.X9LNiL6.3oFT2g0b.490yDOcAhSCr3UncfSbgKq
 bU5Ia4xaZ_j1ruC7YwlGssQPbxsTeKWOcmo7JLOKvq4MfENtS2buqdZicT2N8l8eUGD7kAJNXipB
 MjjXcXs03kfbAO0YvoAEkXmvJoeudgH3XC6qlETJGMiT4a1DESqwAKKVpv_KXRd.fA5Q1Pdg_Rzl
 BdURF8iU4HIkG2q38_9inET6xYWjesEfvSVbif4Trqoca0XaJ2PeqLRATfhJxnFfhAJRlnR9uNdJ
 EfoJQWtEhydRGl5c9jT9MNNduKvq4WVvSFh5RUwBWdnFiNDxdYqeDh28RPa1XO9cDj6WHpD3fkpb
 KI3eskH1kCPJ3xUTwx5_qFK1ksulfB6LqkQ5ELdX5qiw9W5zTGwqvSb5PCASi6lDcQ8.fiT0A_V9
 UUcFeYLCmd5rR3Tfeb.DNGLaXvTEGQljEjQCqJzqWU_YZU0HEOoDbOqOsKVAHIOFanUDjzNowBIK
 hYurk3aYIZAC2KJ2qwW.KQRmKg86Eq.vCO6F.3txp_Ur25.6SMwU4unLFbKVvkSGNs2bf5wBN
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.bf2.yahoo.com with HTTP; Sun, 11 Aug 2019 10:28:07 +0000
Date:   Sun, 11 Aug 2019 10:27:57 +0000 (UTC)
From:   James Berger <jamesbergner398@gmail.com>
Reply-To: jamesbergner398@gmail.com
Message-ID: <1131645976.2837906.1565519277261@mail.yahoo.com>
Subject: My sincere Greetings
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



I am James Berger,

I'm 49 years old, from the united states but I am currently in Syria for peace keeping mission. I am the commanding officer of the third Battalion soldier regime.

Please forgive my manners am not good when it comes to Internet because that is not really my field I actually connected with you from LinkedIn. Here in Syria we are not allowed to go out that makes it very bored for me so I just think I need a friend to talk to outside to keep me going. I would love to get to know the "real" you as a friend.

Respectfully,

James Berger

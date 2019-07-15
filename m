Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 874636985B
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730938AbfGOP0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 11:26:22 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:38451 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730838AbfGOP0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 11:26:22 -0400
Received: from [192.168.178.24] ([109.104.48.170]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mtf39-1ibI8c00aN-00v5Pc; Mon, 15 Jul 2019 17:26:17 +0200
Subject: Re: [PATCH 1/3] ARM: dts: add Raspberry Pi Compute Module 3 and IO
 board
To:     Cyril Brulebois <cyril@debamax.com>, stable@vger.kernel.org
Cc:     charles.fendt@me.com
References: <20190715140112.6180-1-cyril@debamax.com>
 <20190715140112.6180-2-cyril@debamax.com>
From:   Stefan Wahren <stefan.wahren@i2se.com>
Message-ID: <860468a1-df13-cb6a-6951-455cf72ad4a0@i2se.com>
Date:   Mon, 15 Jul 2019 17:26:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190715140112.6180-2-cyril@debamax.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:4DvxEz2EB+kqzew9dTxNHOkFaqkNyUcHb7MD0BYgm795Xzr+dsC
 aU5yg2RrENXmmmxS+wk25RiO+2QFLWkXrjPwMw0AIBrZjFb+6kLc0iTgxD+zzb4C+H9gWJs
 R2KWxJ//k5YtG/CTL7iMJK//8ICePYSOAWjpGMeKG9iI73ZfB3th2k1CghrmdowHmk4XPIq
 uTuKt21pqpp/RuDb83Wpw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:aSkEeBL33xY=:/92f1VJvSjC/81Cnfniu4X
 3NC+XWCE+4CB+BfOxmpvp7AcyCHnrKyLNPbhqOlOW8M9a4IXJ7mWqa31XeVphCvzj4r8crcF2
 oPaGVVnXlWvH6CqOjQ5NLtuBY/cJPy6yNrIevsjcHPU9xeAsj+AcE2XfLm9Q7hGlBe48W2ehi
 U+H1Qu+z03G5MyopBo5Ua0PDPU2NEkz/lmpuOqKjqxK04Uft+L9QXE1rQGSzN6dfRAUaY1G1P
 v9zI+Ym5gt2Y+F4foCj9zQk1nUtfDejbxj6E40JPAeC6tQghB3QaJegX6hRMyAevdCcGbSovP
 kI7YUfNUCzLGX0rIvLliKce2waKihUf4LijiPTbmHiFG7ONDPhQdGNieVCh8kOjFY2d6wiK63
 BnYA0gudSB7m0IVznsbEXTdSC8Qq8Nqr1kGuZP24p0kISCDYMv2neDTfifb/fsT19ZsAC+7C/
 5KLEVEJT7k5P3BTVsf4tl6iwr9Jt1+WZvDSDzkqsGhkYIhbJKn4edEprS4hIsVPv56+szE9p1
 2eO7fFBaVBWH2J3LFlJBBM7+EIrEgtqwQDRQOwMtdNgi1IFwnvHTXvkVEVKGxYI9iRLe+9suP
 M/Gkdrj9bWbsjujM1y1rWsTNHESu1ZOp7HlzjRuvwihB1cr5ORJhIP0nUpVjDIviB+ppG34mH
 Z4xmSYFSRGeM35utRSn1UU48wsQ2R68y+6eKc9l7NcK28gviYtdMBVnk0Fq7E8eO0qiDOUlpE
 StjqRu/PrNFJBds44BId5TvNE6ch14S/xa045ecMtklWYX+NF1e5xhx7qN1OUQyJVjCi1Nju3
 Hp76BgF34twcbYFMem0yQMS4HV+A3aH6/dabDZtgHZra4xvJqDa4CNDmkxWik6E9g8hVTrHcj
 n3Lsfo0A9X9LBFRl78GA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Cyril,

On 15.07.19 16:01, Cyril Brulebois wrote:
> From: Stefan Wahren <stefan.wahren@i2se.com>
>
> commit a54fe8a6cf66828499b121c3c39c194b43b8ed94 upstream.
>
> The Raspberry Pi Compute Module 3 (CM3) and the Raspberry Pi
> Compute Module 3 Lite (CM3L) are SoMs which contains a BCM2837 processor,
> 1 GB RAM and a GPIO expander. The CM3 has a 4 GB eMMC, but on the CM3L
> the eMMC is unpopulated and it's up to the user to connect their
> own SD/MMC device. The dtsi file is designed to work for both modules.
> There is also a matching carrier board which is called
> Compute Module IO Board V3.

this patch series doesn't apply to the stable kernel rules.

Regards
Stefan


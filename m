Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81D11D803C
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgERRgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:36:39 -0400
Received: from sonic311-14.consmr.mail.bf2.yahoo.com ([74.6.131.124]:44429
        "EHLO sonic311-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727006AbgERRgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 13:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1589823398; bh=5gCyJ+OqEpp5mbAlNtNv58P62XCklDNCTlGARRHXZQA=; h=Date:From:Reply-To:Subject:References:From:Subject; b=e5od+LFutpoRf3aFQC4UCMjyvaT0w9ueRV8bbb70LrZHgqWsHOn6AylyNTSsbhOlzFQNah58s+d1L5QhlZkhuLRhhLdtf9eyoCA77HK98Cz0ByAq6boJn46wve8JKI/AOHjl9dJteSH8c2crH5tAbAkrC8ZB7FbIgBnsAeEzaXaAFeGmlvfHtKJklVUXPg8Cx0idI5ueG+7qklPJxRt2WuXSHvZwR86uvY2pjwySw2UC6WQxVJAWVuAQTsD/OzTwyprVNyXiUOq2mP+NF6CHx5BUc/RUcjO/e0ptRSni66hoblDl07s4BkZabFH62qzKKPz7nWkCVle/TUyIUCCnlA==
X-YMail-OSG: djt5Q1kVM1mqx_4jhMf57VH2fgeKEd1Rq1umMDpbgCON1e.VNtTk4MevoWagX2G
 oxYDaFVDb5u1_.scwdGnTXIvOmLksYpaFBzfk1FBLiFpwCXyakOpSMr7ZjQd7SmYieFBvcVCIDTb
 INjp3curEFZbmDl4UdihcuYaqdr2K_xCwCC.PZ8cYeVwPhDFXmssGrYAOkLbdKMt8FPIrAkBkQb0
 a27Yp2RR2fBrSh6L1_wEGHfu14AfeuLtG5APaUlEJyBEoOZfkmFwxRlncJGFSMDOYrPgAFXMOKCp
 E4sGLZBNKXtpNHCzu3SlIXDEP13v92a8qenHkWJHYBn183EE2Bp0CJIoDTc_ECk46AzkgrAvcFKj
 T7DtUQSWIQEvoGVPgJZKYiXxVmnQWrHm8p3Y97KhBYrst3nlEZFdmCRPvOPkl60.I.7vsYB01FLp
 liHoTElTB9G22KSNH5ZfTy9cr5zZRin9Uxiz4caFNfnWzbaPjbShaeePLEa28PvaJh4EK2brBuhG
 JYD9nQK.OIJS5c.WYW1RKxNGQJIeSwOoJArKKO03ZQgIGfbZX4cLbKfqrXoQUyQzAGrcNVHKTkW3
 t00ZEicraUrvLlJkEA_86PSZ3Gyr6htDyDHeTwOHJGaG4MvUXrX8.EymsTxwJ68.2TjzVstzjcvs
 9Rx_1azU4bsaGbUFCXmyp_S6jPTqQ3EHqp0TyNmqLsqmel3IBuedJ.Qs21KbtEMglKPNWLkmOKdw
 2yFgk1byzF43e6vW9rVmdZNEDoCodrgW1lTeKDM4OsmGFRfrj8mrelZLTfTVn_qzqPVy.Fasp.Yb
 TzPJbywsJ.xtIMKifhbuUH30j98cXedA6ksPo46LOj263Q4oePxFpONJy29hfzPl3o0tkXi1nW0J
 s8SMfy_OwyhfjZDyJYRUS3H9527OEHvvRdryoiP57tBZBX3bpMCJb2umZnVttTnnk07Ej1P0AltL
 VuYFgnwHN1.8F1ZikQ8srbwK592sWfM29d2yXzYftHuhhD11Gb2LlRtc1e1coilsFRO.qINNYoMp
 SQSsuPNqsHQpMPTFxZ5kg8PNvi64fcau41OfIdJYGdPTHGLfZHTfwfxuOEF_kgCipg5X3nNaJr9u
 8U9DNm108ObKBh49.6JsBt_l9ylKRtR5sWUTonwRkhkA3oX.R6ofTDB24pcgnV_fQqETdcTtMxYK
 H9enckMn_HGb1zKCKYsCpvHCsZyVxTifcOwtZTTr2pEIlwyOiMuj6KZpz8BeYEGWuTvGdt7xvi7f
 wN6fDSarIgkjtqloxo6vx8o33YGWHd.w29_IWNrM37q.ZPR0NGAoSH9SmesxsD97XfLmI8J4dZZ0
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.bf2.yahoo.com with HTTP; Mon, 18 May 2020 17:36:38 +0000
Date:   Mon, 18 May 2020 17:36:37 +0000 (UTC)
From:   Rose Gordon <rosegordonor@gmail.com>
Reply-To: rosegordonor@gmail.com
Message-ID: <867578004.675506.1589823397033@mail.yahoo.com>
Subject: Hi there
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <867578004.675506.1589823397033.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15960 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:72.0) Gecko/20100101 Firefox/72.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Best of the day to you I'm Rose by name 32years old single lady, Can we be friends? born and raised in London in United Kingdom Take care Rose.

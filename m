Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA634D33AC
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbiCIQKy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 9 Mar 2022 11:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbiCIQIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:08:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C6918FADA
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 08:06:06 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nRyp7-0002pK-Fq; Wed, 09 Mar 2022 17:06:01 +0100
Received: from [2a0a:edc0:0:900:1d::4e] (helo=lupine)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nRyp5-003iR6-At; Wed, 09 Mar 2022 17:05:58 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nRyp4-000AsM-0u; Wed, 09 Mar 2022 17:05:58 +0100
Message-ID: <32e8e44df073db5608d33fd702f7876261a18d0c.camel@pengutronix.de>
Subject: Re: [PATCH v2 1/2] media: coda: Fix reported H264 profile
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Fabio Estevam <festevam@gmail.com>, hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org, nicolas.dufresne@collabora.com,
        ezequiel@collabora.com, kernel@iktek.de, stable@vger.kernel.org,
        Fabio Estevam <festevam@denx.de>
Date:   Wed, 09 Mar 2022 17:05:57 +0100
In-Reply-To: <20220309143322.1755281-1-festevam@gmail.com>
References: <20220309143322.1755281-1-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mi, 2022-03-09 at 11:33 -0300, Fabio Estevam wrote:
> From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> 
> The CODA960 manual states that ASO/FMO features of baseline are not
> supported, so for this reason this driver should only report
> constrained baseline support.
> 
> This fixes negotiation issue with constrained baseline content
> on GStreamer 1.17.1.
> 
> ASO/FMO features are unsupported for the encoder and untested for the
> decoder because there is currently no userspace support. Neither
> GStreamer
> parsers nor FFMPEG parsers support ASO/FMO.
> 
> Cc: stable@vger.kernel.org
> Fixes: 42a68012e67c2 ("media: coda: add read-only h.264 decoder
> profile/level controls")
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> Tested-by: Pascal Speck <kernel@iktek.de>
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> ---
> Changes since v1:
> - Followed Phillip's suggestion to change the commit message to say

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

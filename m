Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBFC6BBA01
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 17:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbjCOQk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 12:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbjCOQkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 12:40:02 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AB89E309;
        Wed, 15 Mar 2023 09:38:40 -0700 (PDT)
Date:   Wed, 15 Mar 2023 17:37:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1678898262;
        bh=KidGruXHor7XV4EUBsRgF3M6u3sjYI7RMC+ogDW/qf0=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=FayKhVDlmUjAT+oKRb3dxw9UkieHODMkoP7dGdTmY4NG/T8gN/8Scozus4uOTSS9w
         bNHi78Mzv4n0y/cM65DfpA/KfLCuJPhoCjC9MXKzEOMrd15724x7MznT4Ryc6EZeUo
         ZJdLAUoPMzpcgOAmp6nk80SE6H+mu99Cp6W0jzoiTheZjPVr7wmWWugrYnFfiykvT9
         GdR3dHi8oe2zdRmZ0uQPgYkOooVKZDnUvgPa5r5WZPTin6x9dJ+JJ/jvtPb7nhpTqV
         s2AiJm4TilUiim6gXzQ1JhNuDRgQR0+OAQOGve9zgsNNu/+QfhuatclR7rv5wApT2y
         6vp8yKKILAlWQ==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1 000/143] 6.1.20-rc1 review
Message-ID: <20230315163741.GA4150@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230315115740.429574234@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.20 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.

Hi Greg

6.1.20-rc1

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>

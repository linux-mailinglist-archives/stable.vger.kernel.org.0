Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764086E8047
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 19:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjDSRYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 13:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbjDSRYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 13:24:08 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5447D90;
        Wed, 19 Apr 2023 10:23:52 -0700 (PDT)
Date:   Wed, 19 Apr 2023 19:23:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1681925030;
        bh=fNTUHSL0ZDLRcl2f5EiJb00luPuYCkua6ejLJanks+Y=;
        h=Date:From:To:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To:Cc:Cc:content-type:content-type:date:date:
         From:from:in-reply-to:in-reply-to:message-id:mime-version:
         references:reply-to:Sender:Subject:Subject:To:To;
        b=p/qh3gSwSjz9sO43HWr8i24rrnu2VJ8B/soyo4WTpszmlpfGeHZlhyKs/Llc2SgE2
         8UaLundvm7edwUV3bmFzTDa7DVuBYjvKKBNGFXGjDYeiKBWBiBZoU5omLEjHS07naW
         61zTU8v/Dg8l7stIlrzh19V7//kD1Dlso/iKUbQVlBMqJC+oc1C8+cZa3pP+q5EQWs
         IuI7r/Fm2/UxmL8a5+eZVBegGc6vk4QSqDo24+Q4CNl48cNMjus0MJoNogn25TWUHS
         KrvfeaQXwWUUUDIAxs8lsBv5wgalHD0jTRNvCX//8GrjlJ/DFVi5X8AvnKDXnjnxvJ
         ifRjeeHRsGv+w==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.2 000/135] 6.2.12-rc3 review
Message-ID: <20230419172349.GE3871@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230419132054.228391649@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419132054.228391649@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.2.12 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 13:20:25 +0000.
> Anything received after that time might be too late.

Hi Greg

6.2.12-rc3

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>

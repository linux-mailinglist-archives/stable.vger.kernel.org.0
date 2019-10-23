Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30D81E2423
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 22:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390077AbfJWUOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 16:14:43 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35867 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfJWUOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 16:14:43 -0400
Received: by mail-ot1-f66.google.com with SMTP id c7so7813010otm.3;
        Wed, 23 Oct 2019 13:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yHCtWGntZMmI9Nauyb+KPzomFg4uDRjl1jF3iEvwjaM=;
        b=Fj+iE2N+xH9VUumDo7aHKQCh2uA/dzMoIp5DfzpEfy+2D2um09sU8SVWke60YX8h4S
         deU1sjupiTV3gDfs3pvKaxdfhW4mIBXCNLOuL1xlscutRoLM4zQ/IzZLscEcNrAf0lVX
         vp8FEv3/rpPLZE3i9fbZ58QUf5PJFJ1ZjTzznZOgk0+hLGWNpQN2GKnwpCU+0AOX6ZtV
         PA1YTidBUfeMS3lhTXrPS7y+NC5csugIYYqoIJoEUI0G55IJgbengcst86PBoM9U6Y4d
         BEkjOGMAOJXLpDiZbwd69zg/eMpF8NbSDqlu2YWu8MecjT244WVYe4/lSeQNBInh8ywB
         Zbeg==
X-Gm-Message-State: APjAAAUSxYnKXnP3B1TcGon2LPUm3g1IICsp5mxOqJX0j57XD+tyoDdE
        JOpI57+Dkf7bvu/mT6BRWJmSfXw=
X-Google-Smtp-Source: APXvYqw1NRgPEgXyubbpFlPakz4U6gDoQjfqDh0u6EixhMw4HkgZOmWsMBDfY/9q/FOxoBgbY7o+sA==
X-Received: by 2002:a05:6830:1f09:: with SMTP id u9mr9254960otg.310.1571861682686;
        Wed, 23 Oct 2019 13:14:42 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id t10sm5992688oib.49.2019.10.23.13.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 13:14:41 -0700 (PDT)
Date:   Wed, 23 Oct 2019 15:14:40 -0500
From:   Rob Herring <robh@kernel.org>
To:     Chris Goldsworthy <cgoldswo@codeaurora.org>
Cc:     robh+dt@kernel.org, Chris Goldsworthy <cgoldswo@codeaurora.org>,
        devicetree@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of: reserved_mem: add missing of_node_put() for proper
 ref-counting
Message-ID: <20191023201440.GA29860@bogus>
References: <1571536644-13840-1-git-send-email-cgoldswo@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571536644-13840-1-git-send-email-cgoldswo@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 19 Oct 2019 18:57:24 -0700, Chris Goldsworthy wrote:
> Commit d698a388146c ("of: reserved-memory: ignore disabled memory-region
> nodes") added an early return in of_reserved_mem_device_init_by_idx(), but
> didn't call of_node_put() on a device_node whose ref-count was incremented
> in the call to of_parse_phandle() preceding the early exit.
> 
> Fixes: d698a388146c ("of: reserved-memory: ignore disabled memory-region nodes")
> Signed-off-by: Chris Goldsworthy <cgoldswo@codeaurora.org>
> To: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-msm@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  drivers/of/of_reserved_mem.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

Applied, thanks.

Rob

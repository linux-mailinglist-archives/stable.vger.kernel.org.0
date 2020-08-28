Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F028B2562C5
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 00:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgH1WCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 18:02:13 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:42671 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgH1WCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 18:02:12 -0400
Received: by mail-il1-f195.google.com with SMTP id t13so1930721ile.9;
        Fri, 28 Aug 2020 15:02:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UGKaYAFNEum4FxcnIc0VNKqc+GCD23shQ5Sl4QgKedE=;
        b=G1LFPOnXccp5nFbfjrcq93QyHtXgGxZEtyUZtW+63k8OkSlK1xKSXWHbLH6H5Vie23
         XgLLgWqd0dOTIQn2fq1o0UMJZk6KC1jU3yT3LyRsl4aUcZkL2c2NgsmOGJaYKcUDq97G
         oiQclYJYFZyD98sEjdVTNOexXP4OXZBc/sP7C5cCK1tjeNaTzZYtl0VFIe826vTDIq1e
         ibnIRD6s2WG/zREzSzHQFajJlSXMKi2pu1t4gVThcTy2yjPKnBRE8SDzU9uurZzPPoTY
         h7S0m9kgVerEzllnl+CNfJfAyv0QhBTS2O5CQ3I9DQQIwrNFhKXHBLu7MxMVzic863p+
         M9tQ==
X-Gm-Message-State: AOAM530AvjVYPs6dxVaQb/MFtoxRu9cY9VawjKGUpAtvY8fh6X6hPven
        g/qTLfAzdz2oPSop5KuZ0A==
X-Google-Smtp-Source: ABdhPJy80Wri053VxDekCxp86h0xBur5yJmFgB/e1RJzrt9LYBKuGx8Jia1ofN3PrJFtflwZYVVWew==
X-Received: by 2002:a92:d8cb:: with SMTP id l11mr713537ilo.221.1598652129767;
        Fri, 28 Aug 2020 15:02:09 -0700 (PDT)
Received: from xps15 ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id v11sm337285ili.66.2020.08.28.15.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 15:02:09 -0700 (PDT)
Received: (nullmailer pid 3482267 invoked by uid 1000);
        Fri, 28 Aug 2020 22:02:07 -0000
Date:   Fri, 28 Aug 2020 16:02:07 -0600
From:   Rob Herring <robh@kernel.org>
To:     Chris Healy <cphealy@gmail.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        maitysanchayan@gmail.com, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, andrew.smirnov@gmail.com, stefan@agner.ch,
        devicetree@vger.kernel.org, srinivas.kandagatla@linaro.org,
        robh+dt@kernel.org, festevam@gmail.com
Subject: Re: [PATCH v4] dt-bindings: nvmem: Add syscon to Vybrid OCOTP driver
Message-ID: <20200828220207.GA3482218@bogus>
References: <20200825030406.373623-1-cphealy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825030406.373623-1-cphealy@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Aug 2020 20:04:06 -0700, Chris Healy wrote:
> From: Chris Healy <cphealy@gmail.com>
> 
> Add syscon compatibility with Vybrid OCOTP driver binding. This is
> required to access the UID.
> 
> Fixes: 623069946952 ("nvmem: Add DT binding documentation for Vybrid
> OCOTP driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Healy <cphealy@gmail.com>
> ---
> Changes in v4:
>  - Point to the appropriate commit for the Fixes: line
>  - Update the Required Properties to add the "syscon" compatible
> ---
>  Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>

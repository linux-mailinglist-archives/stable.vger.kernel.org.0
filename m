Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56134E588D
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 19:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240155AbiCWSl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 14:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbiCWSl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 14:41:26 -0400
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCC91E3F5;
        Wed, 23 Mar 2022 11:39:56 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id k10so2584442oia.0;
        Wed, 23 Mar 2022 11:39:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6IJ7cycfuyyCexwHrRxoU1gZ16ubOu37ElUcjTsxXYM=;
        b=wlZNWcyX2BFTJj9jHXEEegh9pdiRdbQcA7vhY+po6PUKPujJpckeVlGJouvs5f3+ng
         hUfOH3rRkZiP9QG9wWNSBjC58o/9gEj7Kx73uSCM36+XhP4Gj99jqXFHnQ9sJXzkN3C6
         5DuURzfPpK9/eu1TiFDey9xdiVknNMh5Kf+8OYEi6ExhrShsHz5qeODsii6uclPqARx/
         ttRCma6i5h+vTb9dL3HRbDQCYsX5qxijj++2NAR9yHHup+YAHFhCRzSozqumVm3eUydO
         dqc7e12gcr8RT8WCbtOnJGwqggTKBAX64iy7y2V9uWY5RC+zaLDuwCF3jP8Pa9wjMTf8
         CWUA==
X-Gm-Message-State: AOAM533T9jH1gMKYp8lL07BoLXw2rPYsc19/5gSV1B8nbdvzFW9MvDf3
        bwUaA5xULsHEkGykbet63w==
X-Google-Smtp-Source: ABdhPJyHW8ZDlvYfWru61+0oXURh2510vlMRwO3N0Pu7nI+5UqvWri99WhDWPAfwIGOqucmbQllVuw==
X-Received: by 2002:a05:6808:23c8:b0:2ec:cf83:612a with SMTP id bq8-20020a05680823c800b002eccf83612amr5479019oib.255.1648060795836;
        Wed, 23 Mar 2022 11:39:55 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j145-20020acaeb97000000b002d9f37166c1sm279431oih.17.2022.03.23.11.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 11:39:55 -0700 (PDT)
Received: (nullmailer pid 229564 invoked by uid 1000);
        Wed, 23 Mar 2022 18:39:54 -0000
Date:   Wed, 23 Mar 2022 13:39:54 -0500
From:   Rob Herring <robh@kernel.org>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     Maxime Ripard <mripard@kernel.org>, linux-sunxi@lists.linux.dev,
        Chen-Yu Tsai <wens@csie.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 3/3] dt-bindings: arm: sunxi: add A20-olinuxino-lime2
 Revisions G/G1/G2
Message-ID: <Yjtpev468IWa59fx@robh.at.kernel.org>
References: <20220315095244.29718-1-ynezz@true.cz>
 <20220315095244.29718-4-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220315095244.29718-4-ynezz@true.cz>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 15 Mar 2022 10:52:44 +0100, Petr Štetiar wrote:
> Add DT bindings for A20-olinuxino-lime2 Revisions G/G1/G2 boards.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Petr Štetiar <ynezz@true.cz>
> ---
>  Documentation/devicetree/bindings/arm/sunxi.yaml | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>

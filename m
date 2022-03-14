Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F794D8FEF
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 23:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240045AbiCNW6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 18:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237538AbiCNW6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 18:58:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0363A5C7;
        Mon, 14 Mar 2022 15:57:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A1F5B81062;
        Mon, 14 Mar 2022 22:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E38EC340E9;
        Mon, 14 Mar 2022 22:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647298622;
        bh=1UnoAhS6nh3039wEH/W+Pp88txsDR8HCwYuwWJg8MN0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=p3mSGaz5WdNpNkM3AiXL8Ezv/lT4vSUiK1PTyXKB5BSD4QfrBqpxWAGokFNLzBA8A
         EdjeiOYvjW7AJQBzpPYr8fVw01lIKSe7+jaIMgW/OU7+y55e6KMPo6DVKHOmnoLcsO
         jWqSgsqykQfoOiSIdTkTOSzxb51CjO/I4y/LrDuzFQJFwc/wT4/MRXpgcWqDHkIQhU
         geEYYSEurm0yIGll+vVpZaFdyn8n2qmHaZ1ahkh0SzEN53VsmLdGmyJEqgsVGrtF6y
         MThemVtwkfN0TPISEHgB6alXeB3ZgtkN+LIAt9P7zuDgUo6/BkDF5KlB4Mvhl6KILf
         54CefY5C5A6Iw==
Received: by mail-ed1-f50.google.com with SMTP id t1so21766547edc.3;
        Mon, 14 Mar 2022 15:57:02 -0700 (PDT)
X-Gm-Message-State: AOAM532NwTnVDns/x4kVnvIp+fFY0KFTozLVZlj/8Qe1VpgGVXNqkDnp
        J+VszxdR7YcVbG7YZWgyw1SGdNS8nPOIC6NTeg==
X-Google-Smtp-Source: ABdhPJzEUJXMuE34QfdICf2M+C8JZliVvIOHkVBqItKq7URgb9Uv8HLcRbmSHHafEPruhDFDrveUcp3Y69C0fZBSCGI=
X-Received: by 2002:aa7:d147:0:b0:415:c68c:f8d6 with SMTP id
 r7-20020aa7d147000000b00415c68cf8d6mr22808497edo.67.1647298620908; Mon, 14
 Mar 2022 15:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220314181830.245853-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220314181830.245853-1-krzysztof.kozlowski@canonical.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 14 Mar 2022 16:56:49 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJJbQy1DT+MSDTX__V9B0ZVVmD3EeVdBRXyLn6PjxA4GA@mail.gmail.com>
Message-ID: <CAL_JsqJJbQy1DT+MSDTX__V9B0ZVVmD3EeVdBRXyLn6PjxA4GA@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: usb: hcd: correct usb-device path
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 12:18 PM Krzysztof Kozlowski
<krzysztof.kozlowski@canonical.com> wrote:
>
> The usb-device.yaml reference is absolute so it should use /schemas part
> in path.
>
> Reported-by: Rob Herring <robh@kernel.org>
> Fixes: 23bf6fc7046c ("dt-bindings: usb: convert usb-device.txt to YAML schema")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  Documentation/devicetree/bindings/usb/usb-hcd.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Rob Herring <robh@kernel.org>

I've done a meta-schema and found a few more I'll send a patch for.

Rob

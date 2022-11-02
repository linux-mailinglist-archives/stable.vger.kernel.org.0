Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6696163F5
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 14:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiKBNkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 09:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKBNkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 09:40:20 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB7C2AC5B
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 06:40:19 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id 1so17245594vsx.1
        for <stable@vger.kernel.org>; Wed, 02 Nov 2022 06:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=AGvQDfLwfs0KekVGYDJV8ytxVWM0NaZBumlHT6O8jbIp7SGBu69bC7EgVrzAP2GrA1
         j3Kjc99DMz94wtExTTZiWTuPVtqqSLzPLZjT6MJ/Fq9iUkBjgduiyA+AMrd+ERJ7QY3o
         uLvAIoK7PkR7iAERk8YiuLt41jKDiSQWYGCsK3ji2eYlrEvW66zRYGXvWPWv6dm89scH
         UIBjlIKwLif7vNWa3ky48rtK5wHgQUu5MdmQFN8dlTEjC/PBeJj3M/uvNYvgzhdIQxEI
         5P1TG0nC/GmElx5nzxrQrxr8ZOZtbLJShqBfw+BA5tAiJI6qCFgEB4vOPZkfoWx6FM+o
         ScXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=VmngIcjeHEIrlnxJSzBTYICETf2KM328KXKRcujqeSIOUN3BZDAYKKjErd2Bhkw/i8
         HRL1AnJvtX5Xo40k7CnT0zl8exfmHJ3XinHEUAuO60VEs9ePTxXFet8WRvAsgW/ft74X
         IXZ7xyRcDKsn3BOaXfeWzF6GX8EpKFXpColu1nDvw/9hF1VpLF7dkEdYj44JIjYKXiVW
         ELW37Usk78K+VTziZw7a5vo2uIfxO9t1cOLMDC29OsmK+0D04q3rhr+brdAeRjUbDmJl
         Diw6Ab8zqg3+9b2p5P+FuFHM17J2LR4b5naS/7vsrtQVFz1xyWvu/ZFt4kVvF+8YCOCE
         C7oA==
X-Gm-Message-State: ACrzQf07WHiv1blLjitNeogBAFHQRh9rdv/IgTZ/kB/ptlv3SIvtmGSG
        lr1WjhDNtcWsiGvvQ8D9i7UFM7bDqiSR7jzzX/qFyIIg8yc=
X-Google-Smtp-Source: AMsMyM6tdOcjebeGmR+fHa1OERD+f6ebKpWAhWm5/t4Y9Eqp2DvAg6JQjjk8Z5FaFNcxKAuLbUTZGYrYKvZSrPitQRE=
X-Received: by 2002:a05:6102:4420:b0:3ad:19b6:4ef9 with SMTP id
 df32-20020a056102442000b003ad19b64ef9mr4426059vsb.37.1667396418502; Wed, 02
 Nov 2022 06:40:18 -0700 (PDT)
MIME-Version: 1.0
References: <20221102022111.398283374@linuxfoundation.org>
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Wed, 2 Nov 2022 19:10:07 +0530
Message-ID: <CAHokDBnSJUn6m2KGPgfsb_xKZb2n8GrwhmFjVwpStY3kPA_AZQ@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regressions found

Tested-by: Fenil Jain <fkjainco@gmail.com>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C311D5FF381
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 20:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiJNSRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 14:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJNSRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 14:17:22 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113973B458;
        Fri, 14 Oct 2022 11:17:22 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id bs14so6942880ljb.9;
        Fri, 14 Oct 2022 11:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=kmmG16ri/vUL5swIIMa2vak6YbgQOYfxRzdAbXTAi/5FbLoeE3EnJHJ9QlCRWOpaL7
         78XPOja3Tpv/XMPiNeQa/z5QuQ0McIv/2ku3PcGWR3hdzGntM+3Y2SF4SwSVXUrChBFR
         hx1bAjSVsKjpOF802+YJmlTBIG/2dGK9JpEWPUFsUzveOFTBu+gDmHqvHqF1pqNerkDa
         Jv5cv8239bm+P85es+xf1pN1V9z1pEtjoSwcfdFsmJ3hxcS3PixXw0Iv62NUTOcIyFvC
         KCIBenuBtgFMM+IExuEFjY4W0GoOhxxkN5Z9pyxxIDOfUrSApT1bCqm94VT1T/RFAkf0
         NKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=25h18VeFjQ/xOIhOOCyTolMaaod9Ecd5QUViXt82+WodedMWmE8Itop8Lv3jcpQmjY
         ajFT+rHzpYAhx1yUASLf8jZS8JUOGSzpU5ZHSkVXtEf9kpZnVjaYCVkuIvzSaSzZmcP4
         nw8xZ5swI3SS7PWlgvHjealUs+dlKp9zynDbSDxYkFVs0JmHmkuDRB/2ke20LOdRXmXG
         gdk6uapwZrXdOyqeRuNMuZIUY1F75bVNIxjneUcY6a7EsIEEw9CF8apk408wZn6kNxqO
         8w7DMzzxPQ5n24o+4Rf8WRFRcDIVEBIME/dTvtIZDHtMEOkZxbZ1pu1O1oIgzDRXLcu+
         s3Ww==
X-Gm-Message-State: ACrzQf3Pv7k8/kohzWmQUuSP5SpCtQT7igx0l+vkqDZkaI9z1CYUSvkp
        xCDYgNL62TCA4dV4NMbp86kr93sf3cUAo5eG3fonxtPz7MQ=
X-Google-Smtp-Source: AMsMyM7kzZoTx68uI8kyRhjOxe9t/xcebs4vR7MH9HGhVEJbNFsPauTDHKs0FBAhsykAfy5DyG7SuXFOO5JCfZZz284=
X-Received: by 2002:a2e:bea8:0:b0:26f:df23:b047 with SMTP id
 a40-20020a2ebea8000000b0026fdf23b047mr255375ljr.429.1665771440117; Fri, 14
 Oct 2022 11:17:20 -0700 (PDT)
MIME-Version: 1.0
References: <20221013175146.507746257@linuxfoundation.org>
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Fri, 14 Oct 2022 23:47:08 +0530
Message-ID: <CAHokDBmz7=erFmVtEFpxFEKAThRhfAP++U==xtp7oef_WcWiBA@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/34] 6.0.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
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

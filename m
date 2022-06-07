Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47545542001
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 02:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455381AbiFHAFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 20:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574445AbiFGXZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 19:25:44 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB7D3798FE
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 14:36:18 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id h1so15899160plf.11
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 14:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+tlXHJz9kisGrwJfIL/WMzkc1MTPDPH2NkDRgofMQXA=;
        b=CAQl78ghMWdgJpqs5v1tnPv/lepLaq6E6vHOQGSNFpzq0er9j5lbI4PgArppRnxI1i
         OhUHFhwQFCvy16F1fowJJ0nOReoDaAayxdilL8hHuOdrtYQOZkulXHx7HI4Tqfp0C+OG
         Vq9dE/RfMBMoIXhW6yIroAQ9UKNnH2hPxxa8k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+tlXHJz9kisGrwJfIL/WMzkc1MTPDPH2NkDRgofMQXA=;
        b=t0hwosotWxqmHAVc4WOV9kOISZqYN4dUnclzQI3ODv33b8QHWQC8OwX0MIwpyyA3eX
         pAw25/lY7uLPRqxO6lbX68pzEUpBdfSsHNh91MB7gIN2GxTxLjG3dHgQe4z9UEt5HmWJ
         lcyQHQ2XuYV5pDbpJNda5LukAUC5i7TLfA0dvx1RnesSMNN4eudKcSCKY3ZkBMMPjK4l
         PWEE3EGoo8otsWsIFswdy9OpNNNPu0sYqs2c8jjlDUkC67y/W/9zgpVFvpk/gTeuQWAL
         3JuS2GhkovKznTqLMHwXM/uNQNWOhjk7ORzGEdbHcURPSez+W0b+BioS0+EQWy7T4IRp
         10bA==
X-Gm-Message-State: AOAM531/ONUTlg6rMTOIQe+qxH/2HEGM+ffAQYtrKjGBQI+mdThx81dM
        eNFDeLxzT2QvAKyU/domgjqqJg==
X-Google-Smtp-Source: ABdhPJwOhl2xigdWsk9Ip1jYWJh9CMdZiN68xBIN0cOrLS7fUs1z4TCbxFVDM92Dxke6O0smj4+FAA==
X-Received: by 2002:a17:902:9b8a:b0:163:d0ad:f9e8 with SMTP id y10-20020a1709029b8a00b00163d0adf9e8mr30304386plp.79.1654637777427;
        Tue, 07 Jun 2022 14:36:17 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:b689:cc5b:e6ad:930e])
        by smtp.gmail.com with ESMTPSA id q21-20020a056a00085500b0051874318772sm5823056pfk.201.2022.06.07.14.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 14:36:16 -0700 (PDT)
Date:   Tue, 7 Jun 2022 14:36:14 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc:     Heiko Stuebner <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sebastian Fricke <sebastian.fricke@collabora.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: rockchip: Assign RK3399 VDU clock rate
Message-ID: <Yp/EzreGUkFIvwhG@google.com>
References: <20220607141535.1.Idafe043ffc94756a69426ec68872db0645c5d6e2@changeid>
 <253e2771abb13a3e62c07dfb0b420169bb572c2d.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <253e2771abb13a3e62c07dfb0b420169bb572c2d.camel@collabora.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 05:20:41PM -0400, Nicolas Dufresne wrote:
> Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>

Thanks!

> My only doubt was if you really needed to duplicate that setting into gru-
> scarlet.dtsi, but I've simply assumed the answer is yes, and that you already
> checked that.

I didn't explicitly test without modifying gru-scarlet.dtsi, but the
unfortunate nature of these long monolithic
assigned-clocks/assigned-clock-rates properties is that if you want to
add or override one element in the array, you have to repeat (or
override) all of them. And because rk3399-gru-scarlet.dtsi already
overrides some of them, every additional change has to be reflected
there.

That's why it would be much nicer to be able to distribute the
assignments to their various consumer nodes, but as noted in the commit
message (because you mentioned it to me out-of-band ;) ), we can't do
that.

Regards,
Brian

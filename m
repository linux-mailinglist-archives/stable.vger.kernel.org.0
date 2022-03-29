Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7894EA4E8
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 04:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiC2CFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 22:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiC2CFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 22:05:47 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6DD2E0AF;
        Mon, 28 Mar 2022 19:04:06 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id f3so13309174pfe.2;
        Mon, 28 Mar 2022 19:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o1C/N7k3NvBFr+UwK4x8b6ScN+zhLx3X20kO3wGJzGs=;
        b=egQ2/hWe4My+5CfAHOVi0oWqZnTHksJedoVcn4yJ53m9qW9FCmzt7gzVcCIeua6Ghb
         aO+RE19WOQDk253DKTfg5uN8MyJINd8wNIWXksmYAB2LHh28siew51lOd/KQ5JpGgle7
         Jo7Blz1iIcnR3gB4nRS0XcXoebulkpnN5l+AJDa49biNQVT9T+joNrK309Ny2/OKDrs+
         J5Vwm/maFYIHB/RYQxOwnokJUr2AKfow1Up4/2WuTRh51IlDQSTuYlMVqgl4BoK5MzbB
         83SpAq6gJOsKDbxgIhPjkphgovNFhP/QSEFk5AC3qCoO98I+/McDXk8rwoAnkKj4RuSM
         7iAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o1C/N7k3NvBFr+UwK4x8b6ScN+zhLx3X20kO3wGJzGs=;
        b=YsZTOrgqclcEOxyUD9S+4C0EclRSojoZJ6E+indKFlsXegbssGF8y17DiRtjStaPXy
         YqShxvlA3R8ss+CasSTeuk49JIJK72yLs4X4WbPcWPYCOalTO1z5yZDGuVwjtyeuIqNu
         6I7CCqbJdXKWaIn24pRsYomtTp4OGYCPg7NeKvBH16diGl52dfwSUgPQDNDfDD8ELJ7u
         5f8TFStcv0DE/LpzjyriVPaYLSYeRSYby9Qaho3Ml560U+ChDGjKn6J0AdmiWbF2/9MO
         rLys651ah8rGhbCZyBXp5Vpd+u/3LUDY6M0i7ymjwJGBzTiwt+4fw+TFrJdQFAOH9GJ8
         sUPg==
X-Gm-Message-State: AOAM532SUHrEwwnd28c/F4RXK4sXlEsh/DwhHlOAk4D39DoXDypxGJlg
        p6IBI59V+728Sr/MTy1LCVbbXGiWpstf9w==
X-Google-Smtp-Source: ABdhPJxWSoZfrbImbacBCV9Yd4RuUQFxxhBKS47gx0JNznRDIgWtbVrXzE1W6vSRE2UP9qzs2CXo4w==
X-Received: by 2002:a05:6a00:140a:b0:4e0:54d5:d01 with SMTP id l10-20020a056a00140a00b004e054d50d01mr25768620pfu.20.1648519445808;
        Mon, 28 Mar 2022 19:04:05 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id c4-20020a056a00248400b004faad8c81bcsm18203488pfv.127.2022.03.28.19.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 19:04:05 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     dan.carpenter@oracle.com
Cc:     elder@kernel.org, gregkh@linuxfoundation.org,
        greybus-dev@lists.linaro.org, johan@kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        mgreer@animalcreek.com, stable@vger.kernel.org,
        vaibhav.sr@gmail.com, xiam0nd.tong@gmail.com
Subject: Re: [PATCH] greybus: audio_codec: fix three missing initializers for data
Date:   Tue, 29 Mar 2022 10:03:57 +0800
Message-Id: <20220329020357.10597-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220328141944.GT3293@kadam>
References: <20220328141944.GT3293@kadam>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Mar 2022 17:19:45 +0300, Dan Carpenter wrote:
> On Sun, Mar 27, 2022 at 02:01:20PM +0800, Xiaomeng Tong wrote:
> > These three bugs are here:
> > 	struct gbaudio_data_connection *data;
> > 
> > If the list '&codec->module_list' is empty then the 'data' will
> > keep unchanged.
> 
> All three of these functions check for if the codec->module_list is
> empty at the start of the function so these are not real bugs.
> 
> Smatch is supposed to be able to figure this out, but apparently that
> code is broken so Smatch still prints a warning.  :(
> 
> Apparently GCC does not print a warning for this.  Even when I delete
> the check for list_empty() then GCC does not print a warning.  GCC often
> assumes that we enter loops one time.  I haven't looked at that, but I
> have noticed it in reviewing Smatch vs GCC warnings.
> 
> Generally we do not apply static checker work arounds.
> 
> I do not have a problem with this particular work around, but it needs
> an updated commit message which says it is just to silence static
> checker warnings and not to fix bugs.  Remove the Fixes tag.  Don't CC
> stable.

Yes, you are right. I have resend a PATCH with updated commit message as
you suggested, and cc you. Thank you.

--
Xiaomeng Tong

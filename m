Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5904BE921
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345191AbiBUKbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:31:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355314AbiBUKbM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 05:31:12 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39ECE6BDC7
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 01:52:39 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id h6so25994722wrb.9
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 01:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Hyy5zhk9HgrCm82CxymzsiycVHuIg+9Dy7167x4mVwA=;
        b=qeZ6E1GNw9e7qScev3Wmu6Y1ST0mwV2Qgu4grrCEzXV7lF8l3OIIaayrdvP/Fxpg7n
         Dvvh7avJFqFSFVbS9DHr8Z63OybEahZHbp9MUV2j9eBtgjn3GLWudwo3D6F96v5sRdE/
         DqzO96749F9zP9sV27zXHMtA01yQkxBXDF/6HTVe0SadZJeVCQAM9PdQ4CxHDrxLO+1l
         1W9XDiGIxTjzNlJdl7WtuT7HwSRyAEHcT5GhApLRyP94bNfiPSrDd4/Mgd+zLFW8DTP3
         9ozfhjNZYxlNvy9SUQ+rZ6Z3HqcmU53LfxPa9XKGQI9F69lhLVwFla8fF/QBV3RqZW7g
         jUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Hyy5zhk9HgrCm82CxymzsiycVHuIg+9Dy7167x4mVwA=;
        b=svIgcSSUZEnSddptkJ1hueOpHILTOWLxa5OUz9PvQinepds53pLr2Mcv6hdeQRlmPf
         326Y2veExNjX0ipvIKXnX4Okb53MAAa/mpXWTOwQGhxGkXozL+ux6J8n/riFMybVfRI4
         zxIRqApU99BAW2cxgAO4C5nUmDqYBOhv2wKVwhEcrk1o38wDMxR+Zxgdd/CBJyuKvAoy
         nOjIp4tVnPr+pQuhKMvhXoAAwXaXFN/Tfxq7EHzlk4cGtamWWUGfdynu0jjrW+olto9T
         fC4T6YWxYbWMY4bKVq9Gz3DvkUbJ/5KOOGZ8oopvhwNEu6/AqPIawsEPSDwZVYZRH3IR
         kOxg==
X-Gm-Message-State: AOAM533lBJ81uyelGg3Jq4BIIQEsIwnKxfyHy2yfr5/OeG3uGNrFP54/
        3BPGncLo19zAbn9Q2+OlM2RXfQ==
X-Google-Smtp-Source: ABdhPJw2+6NetUKMT7aZ1laddmw9589yadjMa8/BdGeXNRbrwy2ko+NSU3CUv3Ip4f6xbcKVzkBGog==
X-Received: by 2002:adf:f791:0:b0:1e6:8af8:f47d with SMTP id q17-20020adff791000000b001e68af8f47dmr14846790wrp.664.1645437157099;
        Mon, 21 Feb 2022 01:52:37 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id v124-20020a1cac82000000b0037c3d08e0e7sm6838302wme.29.2022.02.21.01.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 01:52:36 -0800 (PST)
Date:   Mon, 21 Feb 2022 09:52:34 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     daniel@iogearbox.net, andrii@kernel.org, ast@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] bpf: Fix toctou on read-only map's
 constant scalar tracking" failed to apply to 5.4-stable tree
Message-ID: <YhNg4uM1gIN89B7U@google.com>
References: <163757721744154@kroah.com>
 <Yg5wY5FKj0ikiq+A@google.com>
 <Yg51IuzfMnU8Uo6v@kroah.com>
 <Yg6AbfbFgDqbhq0e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yg6AbfbFgDqbhq0e@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Feb 2022, Lee Jones wrote:

> On Thu, 17 Feb 2022, Greg KH wrote:
> 
> > On Thu, Feb 17, 2022 at 03:57:23PM +0000, Lee Jones wrote:
> > > Good afternoon Daniel,
> > > 
> > > On Mon, 22 Nov 2021, gregkh@linuxfoundation.org wrote:
> > > > 
> > > > The patch below does not apply to the 5.4-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > 
> > > We are in receipt of a bug report which cites this patch as the fix.
> > 
> > Does the bug report really say that this issue is present in the 5.4
> > kernel tree?  Anything older?
> 
> Not specifically, but the commit referenced in the Fixes tag landed in
> v5.5. and was successfully back-ported to v5.4.144.

Another potential avenue might to be revert the back-ported commit
which caused the issue from v5.4.y.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

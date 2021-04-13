Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00A435DC86
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 12:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245476AbhDMKhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 06:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245151AbhDMKhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 06:37:20 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE0FC061574;
        Tue, 13 Apr 2021 03:37:01 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id f12so15962589wro.0;
        Tue, 13 Apr 2021 03:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xYkMLS3wbgjEUUWQqY7VJ2sWr0LHfQWufcOC/3dXe/U=;
        b=EtuyufGM2Ne9KAroKcpURinKMCk/3vKJH0H/TYHZ/ml+wCTFmUIqzfAPezRpzb9H/A
         KcH1hrXbEzzTejZU0vG6dPe76/vqyKfOaujTJhp6odSBQcQscfZzkiJ7PVSt6ILajU6o
         /Pz0XfHA6pmLTdSRDTnODpSUxddJFaNaBZidweqEpjiBKZ7oo8wE1ZqZ9JtrNO57UTpz
         DFws5VL2YS21VJYJZaGkVzE3QMziY/3/7WbxzzhIfZAQuJuOCDi/RMenbo1vxrdr1+8p
         +E7NdQIpxZh4dQ9hm5KzYJKPVATl0UFytwHCy/M7SUsr+tUOaS1YNlKt1rJA/yyJB4jd
         d+dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xYkMLS3wbgjEUUWQqY7VJ2sWr0LHfQWufcOC/3dXe/U=;
        b=VDULaDdxyg6t/VNjJTIuZXXgYqzit97bQWcJThvuGKfb4VPW1fFF4UIJLVh+tSHrhZ
         7DRf8xGsqDm6KXj9PChyzCIJbXnHE4+/rKIW+yRv7Y1esiSqCNn19AJCX9cTdtgqU62W
         NrSrmRfWImjrjKssRc+wNBAS1Qkqo9VgsxOx0+KNvFpEtRdKgTWGnnHMOyuKRYG8aPaJ
         F/j3xArelyzlt9EcphqXgsxS88JbAYcQwszuXlB+14tPHrGOAC4rm6hsOUeK7E9yQBZo
         ZfAZEvxrvQBb/j1rvvBCaGEe79xH8qtHZG2u654N2mQOUDF7RCUE4KkHlR9cw+eBun53
         QN1w==
X-Gm-Message-State: AOAM533riRUxwIIsONDagTqMLeALqxiU5Wd72/v/CueaJGLSLD989gEb
        Tyg9Rs9W6SqeYND1edtjF976j6g5KTvagw==
X-Google-Smtp-Source: ABdhPJy8McKHzI+D6Y7WdnOYyTYASh3qpKnk1stvB7BAUAgSEHl3mFM168DspVDbjRbvAmGsVmWoDg==
X-Received: by 2002:a5d:6443:: with SMTP id d3mr36626509wrw.292.1618310220015;
        Tue, 13 Apr 2021 03:37:00 -0700 (PDT)
Received: from debian ([78.40.148.180])
        by smtp.gmail.com with ESMTPSA id r5sm20235911wrx.87.2021.04.13.03.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 03:36:59 -0700 (PDT)
Date:   Tue, 13 Apr 2021 11:36:57 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.4 097/111] net: sched: bump refcount for new action in
 ACT replace mode
Message-ID: <YHV0SagpvPYZznFT@debian>
References: <20210412084004.200986670@linuxfoundation.org>
 <20210412084007.483296509@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412084007.483296509@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Apr 12, 2021 at 10:41:15AM +0200, Greg Kroah-Hartman wrote:
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> 
> commit 6855e8213e06efcaf7c02a15e12b1ae64b9a7149 upstream.

This has been reverted upstream by:
4ba86128ba07 ("Revert "net: sched: bump refcount for new action in ACT replace mode"")

--
Regards
Sudip

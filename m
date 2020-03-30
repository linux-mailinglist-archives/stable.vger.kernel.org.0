Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41BE6198044
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 17:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgC3P5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 11:57:06 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36782 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgC3P5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 11:57:06 -0400
Received: by mail-pg1-f195.google.com with SMTP id c23so472277pgj.3;
        Mon, 30 Mar 2020 08:57:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9/4thFLv6op3Zs+mK/Ns7jr79rR0HQCcdVScaqGH3CI=;
        b=tj1Eja5UJgHB96NL+962IyYPtzTxOlfp3jAmd3CwXXw0J66C2swQL4kUxk23rUL42K
         QNgm+LBUm6UZuhoyB5FjB7k0RFBuQA4ZqtGEn8NbknNBGUBsZPDLZH9TMkXB+X6Tve6S
         sqYhEg09/1Im5i40zYP5NmCDDm7fWagyi5JZ2LiZ2cdn8DOEHpftUDWkcPI60ljd12QZ
         cOtPb9Qce23saP9Ba2N33FSEUXN3j3qsxR9cyhw9itDZHOviYBQiqIi3NmVlSpkOb745
         k/zX+QhfCm3EPqLcTpwLU03TtTsJfHt6yuNr2k2H5IqtE4WTaa35dqxL+g3OSaqgakXb
         a6Og==
X-Gm-Message-State: ANhLgQ1mz8T+dpJaM0v66zE71GugG3sB+f5l7vIke2MwHy3sAUkZahyi
        0azZllqLrsQtfGsQUM8MTvSDLOHn
X-Google-Smtp-Source: ADFU+vtihdAM3uF+uZiYX8jQA7Gpu44e6L9q7VAk6bt3CwQo2h+zcGyH16iilVCBjpS3TvXUE3jqXg==
X-Received: by 2002:a63:c09:: with SMTP id b9mr13852057pgl.222.1585583823668;
        Mon, 30 Mar 2020 08:57:03 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id r189sm10026510pgr.31.2020.03.30.08.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 08:57:03 -0700 (PDT)
Date:   Mon, 30 Mar 2020 08:56:59 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     stable@vger.kernel.org
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/i915/gt: Schedule request retirement when
 timeline idles
Message-ID: <20200330155659.GC2022@sultan-box.localdomain>
References: <20200330033057.2629052-1-sultan@kerneltoast.com>
 <20200330033057.2629052-3-sultan@kerneltoast.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330033057.2629052-3-sultan@kerneltoast.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CC'ing relevant folks. My apologies.

Sultan

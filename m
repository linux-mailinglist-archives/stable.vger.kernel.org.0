Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA382C4E1B
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 05:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387684AbgKZEwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 23:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731054AbgKZEwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 23:52:55 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513AEC0613D4
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 20:52:55 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id c198so829551wmd.0
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 20:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zU9xEzy/b7PsU+P9n2/VetmmIVIgqgLwzukBJVNRJCw=;
        b=Rb1aVreXETbTQ9pl2m/AWuaY99TLgfuEyoBfMvHV09aNLvfwXWUibdMnmTaK2/oq1l
         M8jaKmtu+9g3ikx9/4JfcSUaECBorCmETAzM2ShjAshmb1JZZA/sJNpPZ/fJgV+XjTdm
         D24hV9hGjYOrQX4Veztt3NSAGf81yOZtfcVYt2bJ46IetQ1LJYCZfK/ASWS00x/su68N
         vkSo7bR3oDdD9Wj2N5H2XV54CpWyF0ONpo/wKx4HV3+/3ZW75tfGcQTgxDazrq5GYLdz
         OqqlchNOMvMkmcSaa3r9y348neNghoJbaMPdld67WLw+MnSie/IsEGqY/xIOyrGIIBHM
         Yiuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=zU9xEzy/b7PsU+P9n2/VetmmIVIgqgLwzukBJVNRJCw=;
        b=kLEbm4ucC2/fgnx94RrmogEotzlt7PchKZr6v6kmjb33Co7ugIIAzD4l3VohPCCTCa
         ePTif/E7Ykn8lfY4YtlbY7eVOVdvfa3PD0eDTn0kfQo32NCHXFqV6gzm5Ff+UBsdABVv
         PF0yKgLXU7/YWS9yzL+EperiqmYSy9hXNb7yJakZZgyAwEpm7XKKpmnaPsxqeUtgcXEA
         BoWb8kKKdB4VOUl+P5MecI+1Rlxsyymd4jDYYAsXYa7SC/JmUmfCM5Etxnhlgj5Cnsic
         /pUW6LKXHy3hDsuGOqJoBFZKg13ET5LLdv9LjtFaCbb8qNVesMn/RT5UL8+0ZrPvM7Ci
         O2Wg==
X-Gm-Message-State: AOAM533FmTNM6hJmsoqw+Rk95tmr3jhdR4+XMSbBOLdJz1eXgaZBv2t6
        HnCUz+vp6kkO3nrOMOrUq+8CJbB9cQTmNg==
X-Google-Smtp-Source: ABdhPJwsaJGC8DxHZ7SV2IV6adNKbZ0sG3jRP0dyvYT1XdVOCa8qApLhtMS+/8FSMHr/pxPtEANpQw==
X-Received: by 2002:a1c:41c4:: with SMTP id o187mr1185890wma.48.1606366374055;
        Wed, 25 Nov 2020 20:52:54 -0800 (PST)
Received: from lorien (lorien.valinor.li. [2a01:4f8:192:61d5::2])
        by smtp.gmail.com with ESMTPSA id v7sm168747wma.26.2020.11.25.20.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 20:52:53 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Thu, 26 Nov 2020 05:52:52 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Leo Yan <leo.yan@linaro.org>
Cc:     stable@vger.kernel.org, Andrey Zhizhikin <andrey.z@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mike Leach <mike.leach@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Robert Walker <robert.walker@arm.com>,
        Suzuki K Poulouse <suzuki.poulose@arm.com>,
        coresight ml <coresight@lists.linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] perf cs-etm: Change tuple from traceID-CPU# to
 traceID-metadata
Message-ID: <20201126045252.GB20726@lorien.valinor.li>
References: <20201122134339.GA6071@leoy-ThinkPad-X240s>
 <20201125201215.26455-1-carnil@debian.org>
 <X769O4RFFPyfQaDT@eldamar.lan>
 <20201126013522.GB31690@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126013522.GB31690@leoy-ThinkPad-X240s>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Leo,

On Thu, Nov 26, 2020 at 09:35:22AM +0800, Leo Yan wrote:
> On Wed, Nov 25, 2020 at 09:23:23PM +0100, Salvatore Bonaccorso wrote:
> > On Wed, Nov 25, 2020 at 09:12:14PM +0100, Salvatore Bonaccorso wrote:
> > > From: Leo Yan <leo.yan@linaro.org>
> > > 
> > > commit 95c6fe970a0160cb770c5dce9f80311b42d030c0 upstream.
> 
> [...]
> 
> > That's a fallout on my end. Should have said: This is for 4.19
> > specifically to be queued.
> > 
> > Background: in
> > https://lore.kernel.org/stable/20201014135627.GA3698844@kroah.com/
> > 168200b6d6ea0cb5765943ec5da5b8149701f36a was queued up for v4.19.y but
> > the prerequeisite commit was not included and so resulted in build
> > failures with gcc 8.3.0.
> > 
> > The commit was later on reverted but in this thread it was asked to
> > actually make it possible to compile the file as well with more recent
> > gcc versions.
> > 
> > Those two patches to be applied in 4.19.y only pick up a backport of
> > the rerequisite commit 95c6fe970a0160cb770c5dce9f80311b42d030c0 (PATCH
> > 1) followed up by the cherry-pick of
> > 168200b6d6ea0cb5765943ec5da5b8149701f36a again.
> 
> Since the patch 01 is minor tweaked due to context difference, I
> manually compared it with original patch and looks good to me.
> 
> Thank you for the back porting,

Welcome, given I'm unfamiliar with the codebasis for perf the explicit
acknowledgement nothing looks wrong was appreciated.

Regards,
Salvatore

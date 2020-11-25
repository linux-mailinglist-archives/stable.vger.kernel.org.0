Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E631A2C48F6
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 21:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgKYUX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 15:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgKYUX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 15:23:26 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4C0C0613D4
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 12:23:26 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id l1so3154158wrb.9
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 12:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HAsIgb91l988ziBcGNcrP49ar2rihRxhuQj3/0d8grk=;
        b=p53ZlOFh/RjRZUNp2qU+6lIyreVNSDStpLP0mIuq3mVv105aT+lzFR+q1GN5EwDdjk
         7aoYSxYSO3CoPKCKXSdLrbG2qYYpaAyeXjaD1BfDZBQI5liVWnknqpLhSP+KXpBQXIxA
         HORF1DgX/run8oeKQmr04TuwXAuYkVi+1nvHzC/ABj2wGhLzIKp0g0CUGKx+Ph4nBXeR
         XK2WwNYtf6Hpyoslh2R0UPYZE/n1ZdQWw5XqUgEPMJbPjnyqV/u1SkmEAeJwdEAA8AYG
         vPMKqk/tLo7zbsyKX3UQ6awPGRq7T+R/s28YhQu4xXD0Z4DxHxxPaJcChRp/pe1VrMsz
         JtBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=HAsIgb91l988ziBcGNcrP49ar2rihRxhuQj3/0d8grk=;
        b=P1sr8VJ07iGO6hKj8ZiZvlL6Rns9XdPctvP6S6A+OF8xAt4zojrdlYInKp5LcN9Lv5
         7uGLRrtAdMO2PnlIKnVN+7T9cCmaGLPUFp2j4APO5intt6SnjRJD2kdUeMv3Sl2sKO+E
         MfjWFeJ4KLa8ELHI+YCgdz1kIS9tJ46CHnE8s5nDJVTLKmUeZHCBTWfX6B3QaathKLFY
         atNd+pMzX5Pvcr8jPBWS9Ld2cP0JTOVkZ2XHxHLhrRlzWSvYzLo1CD0ua1ewKHugqCKb
         M0R1jmEPguBwqjDUGRdXYcpeKcQ8R5+07Ke5Yl/3yfHH3Hcs6uNJHcCXhQutrIcFAqfc
         vfUw==
X-Gm-Message-State: AOAM530RlRXSnp2IdpSNqreSF63D7adMtkbQQkS1GU89co4ruqScLEUx
        p3WX1NftzGhpCjA1R3zHm74=
X-Google-Smtp-Source: ABdhPJwjH5zp6AbULqjMLlgp2aiGxE2za6uirhO0+Z5fEqxh2RUfIUwMRwnR6DoWuXkzFWBBj2l4IA==
X-Received: by 2002:adf:ecd0:: with SMTP id s16mr5851101wro.415.1606335805217;
        Wed, 25 Nov 2020 12:23:25 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id k81sm7559215wma.2.2020.11.25.12.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 12:23:24 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Wed, 25 Nov 2020 21:23:23 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable@vger.kernel.org
Cc:     Andrey Zhizhikin <andrey.z@gmail.com>,
        Leo Yan <leo.yan@linaro.org>,
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
Message-ID: <X769O4RFFPyfQaDT@eldamar.lan>
References: <20201122134339.GA6071@leoy-ThinkPad-X240s>
 <20201125201215.26455-1-carnil@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125201215.26455-1-carnil@debian.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 25, 2020 at 09:12:14PM +0100, Salvatore Bonaccorso wrote:
> From: Leo Yan <leo.yan@linaro.org>
> 
> commit 95c6fe970a0160cb770c5dce9f80311b42d030c0 upstream.
> 
> If packet processing wants to know the packet is bound with which ETM
> version, it needs to access metadata to decide that based on metadata
> magic number; but we cannot simply to use CPU logic ID number as index
> to access metadata sequential array, especially when system have
> hotplugged off CPUs, the metadata array are only allocated for online
> CPUs but not offline CPUs, so the CPU logic number doesn't match with
> its index in the array.
> 
> This patch is to change tuple from traceID-CPU# to traceID-metadata,
> thus it can use the tuple to retrieve metadata pointer according to
> traceID.
> 
> For safe accessing metadata fields, this patch provides helper function
> cs_etm__get_cpu() which is used to return CPU number according to
> traceID; cs_etm_decoder__buffer_packet() is the first consumer for this
> helper function.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Mike Leach <mike.leach@linaro.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Robert Walker <robert.walker@arm.com>
> Cc: Suzuki K Poulouse <suzuki.poulose@arm.com>
> Cc: coresight ml <coresight@lists.linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Link: http://lkml.kernel.org/r/20190129122842.32041-6-leo.yan@linaro.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> [Salvatore Bonaccorso: Adjust for context changes in
> tools/perf/util/cs-etm-decoder/cs-etm-decoder.c]
> Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>

That's a fallout on my end. Should have said: This is for 4.19
specifically to be queued.

Background: in
https://lore.kernel.org/stable/20201014135627.GA3698844@kroah.com/
168200b6d6ea0cb5765943ec5da5b8149701f36a was queued up for v4.19.y but
the prerequeisite commit was not included and so resulted in build
failures with gcc 8.3.0.

The commit was later on reverted but in this thread it was asked to
actually make it possible to compile the file as well with more recent
gcc versions.

Those two patches to be applied in 4.19.y only pick up a backport of
the rerequisite commit 95c6fe970a0160cb770c5dce9f80311b42d030c0 (PATCH
1) followed up by the cherry-pick of
168200b6d6ea0cb5765943ec5da5b8149701f36a again.

Regards,
Salvatore

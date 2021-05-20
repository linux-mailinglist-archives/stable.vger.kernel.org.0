Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C50F38ADA1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 14:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbhETMJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 08:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbhETMJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 08:09:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C10C01CE8A
        for <stable@vger.kernel.org>; Thu, 20 May 2021 03:43:21 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t11so8930584pjm.0
        for <stable@vger.kernel.org>; Thu, 20 May 2021 03:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IW04GkrcNnLMAgZe3Aeh8iweN6/3sTprJybql0T99eU=;
        b=oPEiuLTy7B21if9MS/Aqe/xhEXvdul2VHQZ2dLfRfAWSFIM/bH0erRY3bvkraCo5Qe
         xFwCGhZIorGqeMga+TcD4N0vDd8s19Mq/WS9TSnb/SC6E9VbtGx7T2DO0Q2uHtp+BlBw
         Mdgn1DuPUHcdJ93Fp3fCYD7eAGBAVr8OpGHJZqwUl29g40s8oL/mj8NLk97bcewn8DMQ
         PEgycLPlx+Yif+9LzRpMunv9EyLAtc491VkCdFn7xDa/4qM0uCbVY8f8Bd+vfh2RFSxa
         HrOg5r5+s/w8jTzF56/Hd6IlWei/Wga2VsiskbrARruT5VsCPP0l1OEgn/PMan0ER5Le
         IWEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IW04GkrcNnLMAgZe3Aeh8iweN6/3sTprJybql0T99eU=;
        b=jojE3uYXLLhAnkS7ROpxp7vbfQapMRkswqoURO0YZdAhyAtPnK9kztwAQ15FRRZ2W5
         RuEUaXVmlsmiZCYddj6UCT04Om3OUpUrbgWXd9Rh17Ti2/TtI2QzS7MA77JMMvgMbaJV
         b7yG4Qq0q/OF3E+JwYr3FdYYFU2x1QGZWRQd7IyF/2vXo/DAXbKLdhC9pe3IjybtCTgU
         +BFK7Ta5Zg48rhBxKEc09zVdxpy0rERF0Jg5zRRQSpVDLTYVzwofh4B1Q936SYSXuck+
         MDy6WklXPrpK2rIwsgMf9QvgURqdy/3UyK3fVMd5jhmazgVhFSTXqQfcOsiFKA4IIQVU
         Ub8A==
X-Gm-Message-State: AOAM531WWJkEc5qZaJi68/xK6DVGXG2Zvico+dECtqgnvak/NuA7D3fE
        pCyv2r18X7GfAJBzrJ/6IAcr
X-Google-Smtp-Source: ABdhPJz64/pJD46QBHy45o4IwFLczk2gwoYOT2rXejR2w6Qbb29ZLdjhx5buftHryFa22aCeRIfe3Q==
X-Received: by 2002:a17:902:cec3:b029:f6:276b:a2b1 with SMTP id d3-20020a170902cec3b02900f6276ba2b1mr1650782plg.71.1621507400944;
        Thu, 20 May 2021 03:43:20 -0700 (PDT)
Received: from thinkpad ([2409:4072:6d8e:dcde:240f:c67:6200:7740])
        by smtp.gmail.com with ESMTPSA id t133sm1928425pgb.0.2021.05.20.03.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 03:43:20 -0700 (PDT)
Date:   Thu, 20 May 2021 16:13:13 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        regressions@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [regressions] ath11k: v5.12.3 mhi regression
Message-ID: <20210520104313.GA128703@thinkpad>
References: <87v97dhh2u.fsf@codeaurora.org>
 <YKYzwBJNTy4Czd1A@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKYzwBJNTy4Czd1A@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 12:02:40PM +0200, Greg KH wrote:
> On Thu, May 20, 2021 at 12:47:53PM +0300, Kalle Valo wrote:
> > Hi,
> > 
> > I got several reports that this mhi commit broke ath11k in v5.12.3:
> > 
> > commit 29b9829718c5e9bd68fc1c652f5e0ba9b9a64fed
> > Author: Bhaumik Bhatt <bbhatt@codeaurora.org>
> > Date:   Wed Feb 24 15:23:04 2021 -0800
> > 
> >     bus: mhi: core: Process execution environment changes serially
> >     
> >     [ Upstream commit ef2126c4e2ea2b92f543fae00a2a0332e4573c48 ]
> > 
> > Here are the reports:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=213055
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=212187
> > 
> > https://bugs.archlinux.org/task/70849?project=1&string=linux
> > 
> > Interestingly v5.13-rc1 seems to work fine, at least for me, though I
> > have not tested v5.12.3 myself. Can someone revert this commit in the
> > stable release so that people get their wifi working again, please?
> 
> How does the mhi bus code relate to a ath11k driver?  What bus is that
> on?
> 

MHI is the transport used by the ath11k driver to work with the WLAN devices
over PCIe.

Regarding the bug, I'd suggest to wait for Bhaumik (the author of 29b9829718c5)
to comment on the possible commit which needs backporting from mainline.

Thanks,
Mani

> This seems odd...
> 
> greg k-h

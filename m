Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FE41A8C50
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 22:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632974AbgDNUSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 16:18:45 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35893 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2632995AbgDNUSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 16:18:42 -0400
Received: by mail-wr1-f67.google.com with SMTP id u13so15570952wrp.3;
        Tue, 14 Apr 2020 13:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VJK0Vudxo6/y/Xzt9pmWLOReg2AXAw6WAxsb6cK2B/Y=;
        b=ItJshrp3HoaZSpcfEuqFDRomRVtr+s3oUL1iG52vnhdTofihJpNg2reeyvbIqHE+HY
         ozsPvx7FTNL+ab4FEHtIkhphJjEVOltgZUk4hQS65FE/hOgA1Zv0akk6Pk9FgmMB3JgS
         tj9/1UHtNYspUea5DKvyB7D2ZgU2r2KuVmd81el+bGCmL1wxgP6IhA9rSiSjhiEB41hW
         QMJB1uyGs9qdWDKDOsvwNvdRgRj3Dkjxq3pNEnRiU9T5Ptq3iUepHrYd0ggb2NbN4aFh
         TTKV/H11EcK26BDg1IrP0Ll+T4tlqB7L5EUkf2mwy+w+TCKO83GfhO9wClwqka/VO57/
         dk2g==
X-Gm-Message-State: AGi0PuY+xkFfs+P74PgPpw7Nuz8XFThs2zF6bql05oMjD/qX9TyyYmhn
        i1GtEcnlWKXkx3c61mR2xqs=
X-Google-Smtp-Source: APiQypI2wicuVpNhjwF5+CR27bkQ8vTSDr5qPsWXW74pMMzNU0KX7GDOUgj1ALCYmwp6aRY+m7xobQ==
X-Received: by 2002:adf:fe03:: with SMTP id n3mr24655532wrr.315.1586895520195;
        Tue, 14 Apr 2020 13:18:40 -0700 (PDT)
Received: from debian (44.142.6.51.dyn.plus.net. [51.6.142.44])
        by smtp.gmail.com with ESMTPSA id w11sm19415437wmi.32.2020.04.14.13.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 13:18:39 -0700 (PDT)
Date:   Tue, 14 Apr 2020 21:18:37 +0100
From:   Wei Liu <wei.liu@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikelley@microsoft.com,
        vkuznets@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] Drivers: hv: vmbus: Fix Suspend-to-Idle for
 Generation-2 VM
Message-ID: <20200414201837.yvmrz5nl5gxgjmqt@debian>
References: <1586663435-36243-1-git-send-email-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586663435-36243-1-git-send-email-decui@microsoft.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 11, 2020 at 08:50:35PM -0700, Dexuan Cui wrote:
> Before the hibernation patchset (e.g. f53335e3289f), in a Generation-2
> Linux VM on Hyper-V, the user can run "echo freeze > /sys/power/state" to
> freeze the system, i.e. Suspend-to-Idle. The user can press the keyboard
> or move the mouse to wake up the VM.
> 
> With the hibernation patchset, Linux VM on Hyper-V can hibernate to disk,
> but Suspend-to-Idle is broken: when the synthetic keyboard/mouse are
> suspended, there is no way to wake up the VM.
> 
> Fix the issue by not suspending and resuming the vmbus devices upon
> Suspend-to-Idle.
> 
> Fixes: f53335e3289f ("Drivers: hv: vmbus: Suspend/resume the vmbus itself for hibernation")
> Cc: stable@vger.kernel.org
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

Applied to hyperv-fixes. Thanks.

Wei.

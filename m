Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4106AA2987
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 00:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfH2WRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 18:17:22 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39760 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727763AbfH2WRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 18:17:21 -0400
Received: by mail-ed1-f66.google.com with SMTP id g8so5736455edm.6
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 15:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VaTFhxoCm9hWeOCO0ElTE9V4VLgj8vESshlNLr9lSt8=;
        b=lOLmUE9y33VatAZwocCWLzD5p0QcedDPRQUx62l97hcFeMqSJqi/P9dFD60pebIFqY
         Xy6sqfSrR8KfT6Z2s3v0QJzxKssQO82njUFDD728x+m0Jl+BjkOgfNDiRKdXcgKa4a2r
         XuLdiP/LUwvPyPUcX8Y6FNvOQ2i/Uk6XYxHrVO7mma9ftj9GL7D+V4K5qGdHPaUlhufZ
         npXFlaOntKEr+Moaf8sCpL6XmOl355INUWSQp+jkxtsRMsPScK9pabEQHw1ahp6HMVAI
         WtOj1CmHg/pBJCEbiDlM3pKaIbEIkPHEV7d8WLkWqWG8A5h+sMlXmeAHPVVtmvMu/AAl
         AiNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VaTFhxoCm9hWeOCO0ElTE9V4VLgj8vESshlNLr9lSt8=;
        b=bQwkC3oAyh01FURnPa2zajot1yutJspqesVOhx4EZCFYQ2EdvRkt5yU4c3MCKlN08t
         3vdBTB4HvBZV4xBRJOxSMcig9jHLzwYVF2ACPBXbX9FeTyUBHUXnQNNhI1zATrRA76pV
         0gmL9BSXe12mXoe8U41PSjfscg+hPPH202uV6TUrGkYKV+88gEoCpROuvCGB6tC1nR6V
         +Rrm6juOpoS8kkiFilKqTHt0mDxtXg8bNuwaEyLnw87lJvFaz+QDG2KyVGDCPWZiLb7a
         8W6Sfv/lEHV2sT2m887RH3+pzhUziqDncD+XWq7c/4k8SlAxduXsSzdQLEWXqY03ImOZ
         UYrw==
X-Gm-Message-State: APjAAAWtnIQSmT3z936wE69L3oIEuP9zNpv9voGa3QkuoxdUGBmHYsnu
        I/LGZIKxdx9v6AUh630rCU/AkA==
X-Google-Smtp-Source: APXvYqw52tG87FkxH5gtCxt1n5cfLEGSFeSVwA4DyF85KDHKVvHgE7gEHO1VVWF/TpY4Z8/AugtmRQ==
X-Received: by 2002:a50:ef04:: with SMTP id m4mr12624736eds.155.1567117040075;
        Thu, 29 Aug 2019 15:17:20 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id l27sm543544ejd.31.2019.08.29.15.17.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 15:17:19 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 287CB10212D; Fri, 30 Aug 2019 01:17:23 +0300 (+03)
Date:   Fri, 30 Aug 2019 01:17:23 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>
Subject: Re: [PATCH AUTOSEL 5.2 51/76] x86/boot/compressed/64: Fix boot on
 machines with broken E820 table
Message-ID: <20190829221723.eicsws3q7gp6nx37@box>
References: <20190829181311.7562-1-sashal@kernel.org>
 <20190829181311.7562-51-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829181311.7562-51-sashal@kernel.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 02:12:46PM -0400, Sasha Levin wrote:
> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> 
> [ Upstream commit 0a46fff2f9108c2c44218380a43a736cf4612541 ]
> 
> BIOS on Samsung 500C Chromebook reports very rudimentary E820 table that
> consists of 2 entries:
> 
>   BIOS-e820: [mem 0x0000000000000000-0x0000000000000fff] usable
>   BIOS-e820: [mem 0x00000000fffff000-0x00000000ffffffff] reserved
> 
> It breaks logic in find_trampoline_placement(): bios_start lands on the
> end of the first 4k page and trampoline start gets placed below 0.
> 
> Detect underflow and don't touch bios_start for such cases. It makes
> kernel ignore E820 table on machines that doesn't have two usable pages
> below BIOS_START_MAX.
> 
> Fixes: 1b3a62643660 ("x86/boot/compressed/64: Validate trampoline placement against E820")
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: x86-ml <x86@kernel.org>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=203463
> Link: https://lkml.kernel.org/r/20190813131654.24378-1-kirill.shutemov@linux.intel.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please postpone backporting the patch (and into other trees). There's a
fixup for it:

http://lore.kernel.org/r/20190826133326.7cxb4vbmiawffv2r@box

-- 
 Kirill A. Shutemov

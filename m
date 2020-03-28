Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A350196381
	for <lists+stable@lfdr.de>; Sat, 28 Mar 2020 05:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgC1EKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 00:10:21 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33802 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgC1EKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Mar 2020 00:10:20 -0400
Received: by mail-pl1-f193.google.com with SMTP id a23so4276189plm.1
        for <stable@vger.kernel.org>; Fri, 27 Mar 2020 21:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=vh2TbZbVBx3YkavFm9bOvpWcwGT8+PaUcA6R4fi4DNg=;
        b=X94Kw6q8foLRNKQalzoVq+KV8BVkM6JfkbMF8qF+q1wTiOFTHdamQaaJUdAHAzkqXQ
         oXfs++WD8LVW84zhH7T5INUDj+Li1dNTNdK/P6Z/op4ynbfMEGqVDyJapwlckYMoA00u
         tTEdL2UYR/WL4aKPYlibxAkZdGI69hnAgpDUBTdkiUutXifthtJMN7v/+yp2gRokGf8H
         7LfbENqVKkAuYvhrnjh2Gj2jynvRIZGN2Z4WWSbblmj18XwSEynbTZPsNjZlo6LWz2NH
         lWRJAJlL0dOpDrV/KoMR7mXtManI9OZzjkIzTgRG7dWPM/v2AqVJVKStvJvklU856QCy
         Aogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=vh2TbZbVBx3YkavFm9bOvpWcwGT8+PaUcA6R4fi4DNg=;
        b=srTgWUbvh1pQ4utMSflCVptEYMctL/r7wAdjQsrAG9uNi3Umax9ScKqH0L3FJIlIid
         HH9iv3xRUR6dubbm0HqzmL32N0MKAWzrH14xAHNNG9An2ME0HgdQ0+PlLkFN7AU+DV0N
         0W2FKCVm5ZKNSqi2J7Iei77cjR0hMOknn7gF0x79KZSVAH7H7xAx1itBxM8OobVWjMes
         /1ez+Om/skRPslxxE56zFUlipi7AM0oaP6tRDmK77lq28lMZLk/f0BrL9NzrdRJ/1rzB
         yL6mfy2aCR3h4IknYRgVGWq82EmIkNbDbX2TSpDS52DTZ0qxaoFS6q8Q12Zf1W+y4Ent
         EsRg==
X-Gm-Message-State: ANhLgQ3a7k6PqeT0neT8EZlpDgj71YLjALcXtgfhAKOdPwJSW3pubgcT
        DzfYDd6pe4PFMoxyTfLOulaOPki2
X-Google-Smtp-Source: ADFU+vvpEkuBpnQzRoqe5ptUsI7JpjZln0ZT2AjNHMjb19+5zeXHdFI+zUU9wxeXvpUad0QuB3LgsQ==
X-Received: by 2002:a17:902:9a98:: with SMTP id w24mr2293475plp.40.1585368619706;
        Fri, 27 Mar 2020 21:10:19 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l5sm4954244pgt.10.2020.03.27.21.10.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Mar 2020 21:10:18 -0700 (PDT)
Date:   Fri, 27 Mar 2020 21:10:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Patches for v4.4.y
Message-ID: <20200328041017.GA258977@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please consider applying the following patches to v4.4.y.

The following patches were found to be missing in v4.4.y by the ChromeOS
missing patches robot. The patches meet the following criteria.
- The patch includes a Fixes: tag
- The patch referenced in the Fixes: tag has been applied to v4.4.y
- The patch itself has not been applied to v4.4.y

All patches have been applied to v4.4.y and chromeos-4-4. Resulting images
have been build- and runtime-tested on real hardware running chromeos-4.4
and with virtual hardware on kerneltests.org.

Upstream commit 14fa91e0fef8 ("IB/ipoib: Do not warn if IPoIB debugfs doesn't exist")
	Fixes: 771a52584096 ("IB/IPoIB: ibX: failed to create mcg debug file")
	in v4.4.y: 771a52584096

Upstream commit efc45154828a ("uapi glibc compat: fix outer guard of net device flags enum")
	Fixes: 4a91cb61bb99 ("uapi glibc compat: fix compile errors when glibc net/if.h included before linux/if.h")
	in v4.4.y: 1575c095e444

Upstream commit c4409905cd6e ("KVM: VMX: Do not allow reexecute_instruction() when skipping MMIO instr")
	Fixes: d391f1207067 ("x86/kvm/vmx: do not use vm-exit instruction length for fast MMIO when running nested")
	in v4.4.y: 0c53038267a9
	Notes:
		This patch also applies to v4.9.y.
		This patch has already been applied to v4.14.y.
		This patch does not affect v4.19.y and later.

Upstream commit b76ba4af4ddd ("drivers/hwspinlock: use correct radix tree API")
	Fixes: c6400ba7e13a ("drivers/hwspinlock: fix race between radix tree insertion and lookup")
	in v4.4.y: 077b6173a8c8

Upstream commit 28d35bcdd392 ("net: ipv4: don't let PMTU updates increase route MTU")
	Fixes: d52e5a7e7ca4 ("ipv4: lock mtu in fnhe when received PMTU < net.ipv4.route.min_pmtu")
	in v4.4.y: 119bbaa6795a
	Notes:
		This patch also applies to v4.9.y.
		This patch also applies to v4.14.y.
		This patch does not affect v4.19.y and later.

Note: I generated this notification manually. I hope I'll have some
automation soon; until then I'll send similar notifications for other
kernel branches as I find the time.

Thanks,
Guenter

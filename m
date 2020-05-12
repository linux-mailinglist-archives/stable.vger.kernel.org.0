Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F373D1CE9F8
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 03:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgELBH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 21:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgELBHY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 21:07:24 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80629C061A0C
        for <stable@vger.kernel.org>; Mon, 11 May 2020 18:07:24 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id e6so8583795pjt.4
        for <stable@vger.kernel.org>; Mon, 11 May 2020 18:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=pjcINeeYai7dpY8/x0UZAQufAmxJ9LPcGA/FV4NZhMo=;
        b=q69P/8AygKuWhFlwwMRv3OjDYGnYv4SBXBBbn2ETTcjDexXfnNXMU/YDkq7qczqEIi
         v8rGQXmRy5p1gAc8YTbILEjypx915UcPLLEbR8bmIZKjIuCfBCsdw1RH7x7zFDDOv8uM
         K8yP+jhH+B5oC6n34tOm9L62cBh7ycNXhq6+8jwzo/eniZOi+eg/BkzMoNVVnSqPEQ1o
         wdFe3l4zBG1C4UEjoZgNrsLU29bUrxqDtJprXUjUdvkTScen1SVIaW/LJbLFziIqf9WW
         /RJYqZehd4QUenE0qAka3ziXnD3uXYjOX782eh+uN+7P+CpXzabLqdrjZb21flnExI/5
         ET3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=pjcINeeYai7dpY8/x0UZAQufAmxJ9LPcGA/FV4NZhMo=;
        b=W4pB4skXW/gZYYYVTA5l2q+hmaVy7ejibz4+96EBBku+WAdMsy+3+gYEoMn/gAmAer
         uP0om9iw8lm26ZdfSlJE5G4Iq+9Eksen0bcMJvKq/KNVQcxc7l4N6VVJij2lLZi7SiU8
         gFRUvcEt34izVNGFn8ef+F2ONqRRlAX690UuHS1KbNoI/g9kN/NIan+2NFph6cgNLps9
         5LYoKqNWp8uziAKcD2iUdkKyCtqS0qeDmiAsFjOFRH7lgpCvHM7kCAT+a2lsd59XHAbG
         wnF0J3OzcvtZWwTL1TPKJec7fZiYbZpYoWu3OFHIJjFM8xXJr1K/fj+SFP3zWNr7MqLM
         zvYg==
X-Gm-Message-State: AGi0Pua+pmQNPFxcPmby3I2LF02gmCcuj/Vf2TGcABgvAqPf4SVBCTpL
        Ffl4AjZaoMgbP8o/XsFzEmB2XbzZ
X-Google-Smtp-Source: APiQypKK/+rIpgtlaJBn6o7FixgNgNnm0p0QhCe8w6OhWA60I7cY4tj0hZZ8+FBWsQH3g4UeCSnmIg==
X-Received: by 2002:a17:902:dc86:: with SMTP id n6mr18245560pld.198.1589245643450;
        Mon, 11 May 2020 18:07:23 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 127sm10473269pfw.72.2020.05.11.18.07.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 May 2020 18:07:22 -0700 (PDT)
Date:   Mon, 11 May 2020 18:07:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: List of patches to apply to stable releases (5/11)
Message-ID: <20200512010721.GA221140@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please consider applying the following patches to the listed stable releases.

The following patches were found to be missing in stable releases by the
Chrome OS missing patch robot. The patches meet the following criteria.
- The patch includes a Fixes: tag
- The patch referenced in the Fixes: tag has been applied to the listed
  stable release
- The patch has not been applied to that stable release

All patches have been applied to the listed stable releases and to at least one
Chrome OS branch. Resulting images have been build- and runtime-tested (where
applicable) on real hardware and with virtual hardware on kerneltests.org.

Thanks,
Guenter

---
Upstream commit fd25ea29093e ("Revert "ACPI / video: Add force_native quirk for HP Pavilion dv6"")
  upstream: v4.10-rc6
    Fixes: 6276e53fa8c0 ("ACPI / video: Add force_native quirk for HP Pavilion dv6")
      in linux-4.4.y: 69e236e70ead
      in linux-4.9.y: a04465251f94
      upstream: v4.10-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y

Upstream commit 56f772279a76 ("enic: do not overwrite error code")
  upstream: v4.18-rc2
    Fixes: e8588e268509 ("enic: enable rq before updating rq descriptors")
      in linux-4.4.y: 6af8cf3ca5cb
      in linux-4.9.y: 92ff7ff0318f
      in linux-4.14.y: 87337cb5663c
      upstream: v4.17-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y (already applied)
      linux-4.14.y (already applied)

Upstream commit afe49de44c27 ("ipv6: fix cleanup ordering for ip6_mr failure")
  upstream: v4.19-rc3
    Fixes: 15e668070a64 ("ipv6: reorder icmpv6_init() and ip6_mr_init()")
      in linux-4.4.y: 7c5deeccc664
      in linux-4.9.y: 05a59bc2f3c0
      upstream: v4.11-rc3
    Affected branches:
      linux-4.4.y
      linux-4.9.y (already applied)
      linux-4.14.y
        [commit 15e668070a64 is in v4.14 and thus in v4.14.y but its fix isn't]

Upstream commit bbdc6076d2e5 ("binfmt_elf: move brk out of mmap when doing direct loader exec")
  upstream: v5.2-rc1
    Fixes: eab09532d400 ("binfmt_elf: use ELF_ET_DYN_BASE only for PIE")
      in linux-4.4.y: 7eb968cd04d4
      in linux-4.9.y: 63c2f8f8c41b
      upstream: v4.13-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y
      linux-4.14.y (already applied)
      linux-4.19.y (already applied)

Upstream commit 6f6060a5c9cc ("x86/apm: Don't access __preempt_count with zeroed fs")
  upstream: v4.18-rc6
    Fixes: dd84441a7971 ("x86/speculation: Use IBRS if available before calling into firmware")
      in linux-4.4.y: 7ec391255421
      in linux-4.9.y: a27ede1bedcb
      in linux-4.14.y: c3ffdb5a2ed4
      upstream: v4.16-rc4
    Affected branches:
      linux-4.4.y
      linux-4.9.y (already applied)
      linux-4.14.y (already applied)

Upstream commit 612601d0013f ("Revert "IB/ipoib: Update broadcast object if PKey value was changed in index 0"")
  upstream: v4.14-rc3
    Fixes: 9a9b8112699d ("IB/ipoib: Update broadcast object if PKey value was changed in index 0")
      in linux-4.4.y: 8716c87ec253
      in linux-4.9.y: 089f13786bdc
      upstream: v4.12-rc1
    Affected branches:
      linux-4.4.y
      linux-4.9.y (already applied)

Upstream commit 778fbf417999 ("HID: wacom: Read HID_DG_CONTACTMAX directly for non-generic devices")
  upstream: v5.7-rc5
    Fixes: 184eccd40389 ("HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report")
      in linux-4.14.y: 4e268e9c404a
      in linux-4.19.y: 8993c673d6c4
      upstream: v5.3-rc1
    Affected branches:
      linux-4.14.y
      linux-4.19.y
      linux-5.4.y
      linux-5.6.y

Upstream commit f9094b7603c0 ("geneve: only configure or fill UDP_ZERO_CSUM6_RX/TX info when CONFIG_IPV6")
  upstream: v4.15-rc1
    Fixes: fd7eafd02121 ("geneve: fix fill_info when link down")
      in linux-4.14.y: 81a1c2d3f9eb
      upstream: v4.15-rc1
    Affected branches:
      linux-4.14.y

Upstream commit 57d38f26d81e ("vt: fix unicode console freeing with a common interface")
  upstream: v5.7-rc5
    Fixes: 9a98e7a80f95 ("vt: don't use kmalloc() for the unicode screen buffer")
      in linux-4.19.y: b91c4171c74e
      in linux-5.4.y: 64882aa0c531
      in linux-5.6.y: ec6e885a4cb0
      upstream: v5.7-rc3
    Affected branches:
      linux-4.19.y
      linux-5.4.y
      linux-5.6.y

Upstream commit 145cb2f7177d ("sctp: Fix bundling of SHUTDOWN with COOKIE-ACK")
  upstream: v5.7-rc3
    Fixes: 4ff40b86262b ("sctp: set chunk transport correctly when it's a new asoc")
      in linux-4.19.y: cbf23d40cece
      upstream: v5.0-rc4
    Affected branches:
      linux-4.19.y
      linux-5.4.y
      linux-5.6.y

Upstream commit 2ae11c46d5fd ("tty: xilinx_uartps: Fix missing id assignment to the console")
  upstream: v5.7-rc5
    Fixes: 18cc7ac8a28e ("Revert "serial: uartps: Register own uart console and driver structures"")
      in linux-5.4.y: c4606876164c
      in linux-5.6.y: 29772eb399a3
      upstream: v5.7-rc3
    Affected branches:
      linux-5.4.y
      linux-5.6.y

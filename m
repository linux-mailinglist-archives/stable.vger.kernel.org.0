Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665DB535117
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 16:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbiEZO5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 10:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbiEZO5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 10:57:41 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CCF1056B
        for <stable@vger.kernel.org>; Thu, 26 May 2022 07:57:40 -0700 (PDT)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 646983F369
        for <stable@vger.kernel.org>; Thu, 26 May 2022 14:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1653577057;
        bh=nsXw0kqux34FDNrqRrDs0G3sELyi/AzZ5A/Fizj2V/A=;
        h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type;
        b=a6Oabchey3F5xv4+/ZSfFJ1JTxeIQNne2+DGlbHbDqzYLcUjAx8K5byaC08ItpQpE
         M30LMk1e4p8s1PFSb4P0jzGowOxlga4bbH5gUxjdkUyx3QtTbKtq2yGx4E4NOuq9dl
         MskarBqYvM+uq2WNze4DR+mTS1dtWjE8E9bwfoLtXBUagknUWBRcn+FWq0rlYM1aX1
         LHnR5+UgsXnwkmU0mTq37n3283WA1OB1qCXAx7oCexcKI9pJ/s3hQ9yjnBPYxVTZ9H
         LAc0wqPLiXGQ1OeKfUyEWwHa9NzJH5cMZuVlQjWjzUUyibeZZ6AuLUCzRidbJMS7Vh
         LMu7+AhPw+dYw==
Received: by mail-io1-f72.google.com with SMTP id i189-20020a6bb8c6000000b0065e475f5ca9so1159668iof.15
        for <stable@vger.kernel.org>; Thu, 26 May 2022 07:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=nsXw0kqux34FDNrqRrDs0G3sELyi/AzZ5A/Fizj2V/A=;
        b=OV0QlfTg/EKCgaFaEhOM44uPL1cpdzCeI8yNjiAJF4CxKAP32nQgTGPSAVLMrQ0MB7
         Y1GTReDkkeA8BJg3Ulmijm2u3R2LiIHrfCKxh4g4KZ1oq4vpOdpp4lzYg76hORKnhBWH
         cLuI0CRQg+hBILbBTWkBWYPkz/sXCMlCE1TxNKvqTvxR33AeVCFeTYu0TYS0ijlWeDsN
         JBjfWWPw5GriPXJKVMcJK1mH39oiFzt31ozNNvJ8K/de/+JgwA1DxZ0QaG1O7m03slJx
         eiz+Gp+s6WSDsUuWxqreesjNX2ET29T0iR/4g2EknsVEWCz0BMb6rGYby08CjleVP7R3
         ipNQ==
X-Gm-Message-State: AOAM5337ih5iNul3QOMvRg1yIGRrvXoC1WGIcoH0qxx1RqMsW8pKa0Zk
        Dw5QHpgIi+Geap11UF77I9hbS4QQxi/Sh+6w4uR8NRmicgqHofWJApY/MqvdlMT67H/+EaoT+Wl
        GKe2kdG9xXEaCHWssMHtV18+A5ImyVjhxsA==
X-Received: by 2002:a5d:9f42:0:b0:654:9a2b:cab1 with SMTP id u2-20020a5d9f42000000b006549a2bcab1mr17203536iot.89.1653577052574;
        Thu, 26 May 2022 07:57:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnWOaZF3xQ3UVsIQjNZvqBgtBoj6qPMoDAsK0Kl3sD8RxqNfEJeIOTOxYKCWwusrvW6H+SJA==
X-Received: by 2002:a5d:9f42:0:b0:654:9a2b:cab1 with SMTP id u2-20020a5d9f42000000b006549a2bcab1mr17203526iot.89.1653577052371;
        Thu, 26 May 2022 07:57:32 -0700 (PDT)
Received: from xps13.dannf (c-73-14-97-161.hsd1.co.comcast.net. [73.14.97.161])
        by smtp.gmail.com with ESMTPSA id f4-20020a02a804000000b0032b3a7817acsm446516jaj.112.2022.05.26.07.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 07:57:31 -0700 (PDT)
Date:   Thu, 26 May 2022 08:57:28 -0600
From:   dann frazier <dann.frazier@canonical.com>
To:     stable@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Aristeu Rozanski <aris@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Avoid Oops reading ACPI BERT table in sysfs on ARM systems
Message-ID: <Yo+VWA+zaTGIcvrL@xps13.dannf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hey Greg,

  I'm proposing the following commits for stable, as they fix an
oops we're seeing in our testing[*]:

This is needed to 4.14.y -> 5.18.y:
1bbc21785b73 ACPI: sysfs: Fix BERT error region memory mapping

A dependency of the above, needed for 4.14.y -> 5.10.y
bdd56d7d8931 ACPI: sysfs: Make sparse happy about address space in use

  -dann

[*] https://launchpad.net/bugs/1973153

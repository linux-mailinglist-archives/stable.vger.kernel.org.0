Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE02E591774
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 00:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237356AbiHLWy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 18:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiHLWy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 18:54:26 -0400
X-Greylist: delayed 415 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 12 Aug 2022 15:54:24 PDT
Received: from smtp2.hushmail.com (smtp2.hushmail.com [65.39.178.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CF58E0FE
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 15:54:24 -0700 (PDT)
Received: from smtp2.hushmail.com (localhost [127.0.0.1])
        by smtp2.hushmail.com (Postfix) with SMTP id 09B1B180BE21
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 22:47:29 +0000 (UTC)
X-hush-tls-connected: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=hushmail.com; h=date:to:subject:from; s=hush; bh=8gJRGhk5OXmIz/Er6016GcNlre5dK0sPJDnT2UKewW4=; b=dFc2GhDDpk3vksnCTjLB6rA/wvM2/6yMyoMROpMGGGH/+BJtHRjBW3hcGTCexo19cvS7CyCtt2XFshCI869e/PH5NtvtEopFgP02U5VmaFo+zvbinh46hci1yl7dr4Y9iDbQT4lM88k5+NKsOeSVKP3Q8n63RaQujBPKGBESddOpoDrK22ZLr58FPuVs/fqAuwJSI5aDIaAHulfmUpBJu08laO2Vh/IP/H5v8UJkDH7KoNJCUhsYN7FSLkRLzkfMt6OdB2DyRBqRlrieJqF/ribUqud+HgZpDxKf9cskKzc/lC0iShqecIlddRO3RTmvHNrsv6WkQdbaYp0rjJ5xwQ==
Received: from smtp.hushmail.com (w9.hushmail.com [65.39.178.29])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smtp2.hushmail.com (Postfix) with ESMTPS
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 22:47:28 +0000 (UTC)
Received: by smtp.hushmail.com (Postfix, from userid 48)
        id C94E18106BC; Fri, 12 Aug 2022 22:47:28 +0000 (UTC)
MIME-Version: 1.0
Date:   Sat, 13 Aug 2022 10:47:28 +1200
To:     stable@vger.kernel.org
Subject: AMD RX580 GPU
From:   cmiles69@hushmail.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20220812224728.C94E18106BC@smtp.hushmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linux voidshop 5.15.52_1 #1 SMP Sat Jul 2 15:17:21 UTC 2022 x86_64 GNU/Linux. This kernel runs fine.

Every other later kernel does not.

kern.err: [  128.868336] amdgpu 0000:29:00.0: [drm] *ERROR* [CRTC:53:crtc-0] flip_done timed out

This is the error i get when coming back from playing a wine game ( Sacred gold ).

Screen freezes, although sometimes i can type sudo reboot and it works.

Trying different kernel options.

GRUB_CMDLINE_LINUX_DEFAULT="amdgpu.noretry=0 pci=noats udev.log_priority=3 idle=nomwait radeon.si_support=0 radeon.audio=0 radeon.cik_support=0 amd_iommu=fullflush amdgpu.si_support=1 amdgpu.cik_support=1 amdgpu.dc=1 amdgpu.dpm=1 amdgpu.modeset=1 ipv6.disable=1 raid=noautodetect nomdadm vt.default_utf8=1"

Can i provide any other information ?.

Please advise

Craig Miles


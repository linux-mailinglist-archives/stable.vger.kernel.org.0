Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7D2686E5C
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 19:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbjBASrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 13:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbjBASrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 13:47:08 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557DB74A74
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 10:47:06 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 65AF732009A4;
        Wed,  1 Feb 2023 13:47:05 -0500 (EST)
Received: from imap47 ([10.202.2.97])
  by compute2.internal (MEProxy); Wed, 01 Feb 2023 13:47:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=octaforge.org;
         h=cc:cc:content-type:date:date:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1675277225; x=1675363625; bh=7qEMG9ZI2llbvFtAMUYr2ItZhnmpvWaxYO+
        71EGMdzc=; b=INv99ZfkWeItyE83F/cX5lbDa2hjkXEdlwtAqoGOo2YFcZPgKNQ
        r3dvd+0D7UhuRYE8uADdtb1w72J1xLAI8bdgg24ovVxJuVBdffpmanFIO1bLCHNT
        U35VCa89dHtB+35WaQxfafXbLf9v5tXa3Hvtp/ZOrX23Z+KKm8lvYWHHsk/uomip
        CL/06w4f9odcQdRhdscvVyQqxjUpc95jGfDyMTSNxFuTI2W2bQ44DHrKgaXauUgf
        IVZi6ZUiPGmT9Lt388eaXDNZBB4S4HeuOGxL+QSE9/ZH2E7AwfnLhwlcUCSBwaNq
        DuPlnsZxw7HRK3813Spvo1KZDRxB01e9fKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:message-id:mime-version
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1675277225; x=
        1675363625; bh=7qEMG9ZI2llbvFtAMUYr2ItZhnmpvWaxYO+71EGMdzc=; b=E
        IFs4VgEvQNXkmEOTFPnGKMlAz/4XRrlwMdqNNXdqfSxUAzZg/gxm4ftANR6jrX24
        QSz99s8UVdPVFmPBHn3UIVMWTQ/+c7AEy2/+zZuWxuurZjP+ZtTtuZBdKCr+20pN
        J0DldCvDRdE0FGmPIA8LEymr9LUTwl7Um1XBfkuswZBsNfvc75HXDE3SKlCDn2zN
        XKnxebg9u882KhBDI1xAGFMVMoHlRt/0jf3GdKmGBgnaRmWQuxw3qGJSDV8J/vt4
        cEpGg9Y9SFxU7n6Kr6K5eK3P1/LR7jFUl/QCT6BHKKHzRz24JyW0i5H7SaXMHYgm
        4qVRwv9842uZ0wrc9t4Uw==
X-ME-Sender: <xms:qLPaY9hRz_-HPuOvvWMGeQezLKvSPLgzMuBYOOuPIjF2b7BEyarupA>
    <xme:qLPaYyAF5DmxUDZs75Y8yMFFEk_7PpxmWaWlUJG4cxelW5ixCaJO-LHpaeQgIMh3t
    84DDyy0rFq6VLfSrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefiedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepofgfggfkfffhvfevufgtsehttd
    ertderredtnecuhfhrohhmpedfffgrnhhivghlucfmohhlvghsrgdfuceouggrnhhivghl
    sehotghtrghfohhrghgvrdhorhhgqeenucggtffrrghtthgvrhhnpeetfeeifedvudegff
    elheefleffveejvdetteeljeeihfekheevledttdelteejjeenucffohhmrghinhepfhhr
    vggvuggvshhkthhophdrohhrghdpghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepuggrnhhivghlsehotghtrghfohhr
    ghgvrdhorhhg
X-ME-Proxy: <xmx:qLPaY9FGkfPXSt7cYWjNPSphPkMtqlbagB6yCc62nXufqf5gLMxApA>
    <xmx:qLPaYyRZCgZFQBzLnhpNr0pZEFf0dfF628rBS8Alf_RY_NSNAwMBgg>
    <xmx:qLPaY6wQ8n9o7uFiSArpRjqqJJKlSJPd33uWbD1uyfGelxIRz_FB2Q>
    <xmx:qbPaY0vNEraNqzC4aLXChoFslb-jCmr8AbzwC-1C0w2_wWsKFP0Uuw>
Feedback-ID: ib9f842dd:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 70EDDA6007C; Wed,  1 Feb 2023 13:47:04 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-107-g82c3c54364-fm-20230131.002-g82c3c543
Mime-Version: 1.0
Message-Id: <dab9cbd8-2626-4b99-8098-31fe76397d2d@app.fastmail.com>
Date:   Wed, 01 Feb 2023 19:46:07 +0100
From:   "Daniel Kolesa" <daniel@octaforge.org>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     dan@danny.cz, amd-gfx@lists.freedesktop.org,
        tpearson@raptorengineering.com, alexdeucher@gmail.com,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: [PATCH] drm/amdgpu: drop the long-double-128 powerpc check/hack
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit c653c591789b ("drm/amdgpu: Re-enable DCN for 64-bit powerpc")
introduced this check as a workaround for the driver not building
with toolchains that default to 64-bit long double.

The reason things worked on 128-bit-long-double toolchains and
not otherwise was however largely accidental. The real issue was
that some files containing floating point code were compiled
without -mhard-float, while others were compiled with -mhard-float.

The PowerPC compilers tag object files that use long doubles with
a special ABI tag in order to differentiate 64-bit long double,
IBM long double and IEEE 128-bit long double. When no long double
is used in a source file, the file does not receive the ABI tag.
Since only regular doubles are used in the AMDGPU source, there
is no ABI tag on the soft-float object files with 128-bit-ldbl
compilers, and therefore no error. With 64-bit long double,
the double and long double types are equal, and an ABI tag is
introduced.

Of course, this resulted in the real bug, which was mixing of
hard and soft float object files, getting hidden, which makes
this check technically incorrect.

Since then, work has been done to ensure that all float code is
separately compiled. This was also necessary in order to enable
AArch64 support in the display stack, as AArch64 does not have any
soft-float ABI, and all code that does not explicitly conatain
floats is compiled with -mgeneral-regs-only, which prevents
float-using code from being compiled at all. That means AArch64
support will from now on always safeguard against such cases
happening ever again.

In mainline, this work is now fully done, so this check is fully
redundant and does not do anything except preventing AMDGPU DC
from being built on systems such as those using musl libc. The
last piece of work to enable this was commit c92b7fe0d92a
("drm/amd/display: move remaining FPU code to dml folder")
and this has since been backported to 6.1 stable (in 6.1.7).

Relevant issue: https://gitlab.freedesktop.org/drm/amd/-/issues/2288

Signed-off-by: Daniel Kolesa <daniel@octaforge.org>
---
 arch/powerpc/Kconfig                | 4 ----
 drivers/gpu/drm/amd/display/Kconfig | 2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b8c4ac56b..267805072 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -289,10 +289,6 @@ config PPC
 	# Please keep this list sorted alphabetically.
 	#
 
-config PPC_LONG_DOUBLE_128
-	depends on PPC64 && ALTIVEC
-	def_bool $(success,test "$(shell,echo __LONG_DOUBLE_128__ | $(CC) -E -P -)" = 1)
-
 config PPC_BARRIER_NOSPEC
 	bool
 	default y
diff --git a/drivers/gpu/drm/amd/display/Kconfig b/drivers/gpu/drm/amd/display/Kconfig
index 2efe93f74..94645b6ef 100644
--- a/drivers/gpu/drm/amd/display/Kconfig
+++ b/drivers/gpu/drm/amd/display/Kconfig
@@ -8,7 +8,7 @@ config DRM_AMD_DC
 	depends on BROKEN || !CC_IS_CLANG || X86_64 || SPARC64 || ARM64
 	select SND_HDA_COMPONENT if SND_HDA_CORE
 	# !CC_IS_CLANG: https://github.com/ClangBuiltLinux/linux/issues/1752
-	select DRM_AMD_DC_DCN if (X86 || PPC_LONG_DOUBLE_128 || (ARM64 && KERNEL_MODE_NEON && !CC_IS_CLANG))
+	select DRM_AMD_DC_DCN if (X86 || PPC64 || (ARM64 && KERNEL_MODE_NEON && !CC_IS_CLANG))
 	help
 	  Choose this option if you want to use the new display engine
 	  support for AMDGPU. This adds required support for Vega and
-- 
2.34.1

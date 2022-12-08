Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3930646981
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 08:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiLHHAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 02:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLHHAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 02:00:21 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC546F0F9
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 23:00:20 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id s9so156148qtx.6
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 23:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OABekI9FuwaEzpvvLVchknzlLc2CzmKMSx1uK2JBTfw=;
        b=Xmg9z0JubCpB+VRs9tnUaKidIX+QDZGyS+wUcXqMXGskdvwtkx/4xxiIm96v7FjQ5T
         qxzSOWcAUx2PSH6rw9y9HLFa7jdRoFMgvFKRi2RoLri+XASinskOQz0M+Zc2ETGHgeaj
         fpmq+mL50SSkkROXUT44QeGgw0TuCfbt6othM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OABekI9FuwaEzpvvLVchknzlLc2CzmKMSx1uK2JBTfw=;
        b=5/NJxzrZu4dj0eJX6gZnM37/FXCEHzQq3SHUQKrnrSBf2kll2u+A/+Iw+9V5SKlW7+
         wKui5IsFSNbK8sBoiu4FLfQdx9FiNqqQRX2MkxwJ7wSrtCFsOHJOCcQRUR29UdDYQkjA
         AOgsLmd0DkDE9wej35AGqbvKdXMStQykZtg/85qzSKJxE77mOhmEYN/lcGQvJk7M8G7S
         Ig8j2kJRznHJ9Yt2WrqwWyZWcPWsAa9SCvlEmKCj2UAoXAdVkV1ZEj47ZYwBI65WKkMa
         yeurN8sP4HXkh+vS0Pu3oIJMiBLlHsn+hzl7LHyMHUpOuF8zUTKpN/9FzDP4Y9Rmeu3j
         BnRA==
X-Gm-Message-State: ANoB5pki1kKJu/QS8eqbnpcq2qDVLLqokt/tFbqiC4FHFX6i5jXcwVcT
        ZutyHAtWeRYG/ILqy4//kxzf4ejSATDd0if5gS0=
X-Google-Smtp-Source: AA0mqf7rCl7zK6StCS2ehD0/YOOWdKKyDl/FGHCbtkTI/8AQRHHEU07KgB62e5f6nyQUEs/ocYhMEA==
X-Received: by 2002:a05:622a:6112:b0:3a6:9c36:e3b1 with SMTP id hg18-20020a05622a611200b003a69c36e3b1mr2354575qtb.42.1670482819078;
        Wed, 07 Dec 2022 23:00:19 -0800 (PST)
Received: from localhost (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id hj6-20020a05622a620600b003972790deb9sm14449806qtb.84.2022.12.07.23.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 23:00:18 -0800 (PST)
Date:   Thu, 8 Dec 2022 07:00:18 +0000
From:   Joel Fernandes <joel@joelfernandes.org>
To:     stable@vger.kernel.org
Cc:     paulmck@kernel.org
Subject: Please apply 8f15c682ac5a (rcutorture: Automatically create initrd
 directory) to 4.19
Message-ID: <Y5GLgvhNpGe1V/RI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Could you please apply 8f15c682ac5a ("rcutorture: Automatically create initrd
directory") to 4.19 stable kernels. The patch made it in 5.0.

This is required to make rcutorture work, without it I get build failures
like so:

CC      arch/x86/mm/init_64.o
CC      arch/x86/kernel/cpu/mcheck/mce.o
/home/joelaf/repo/chromiumos/chromiumos/src/third_party/kernel/v4.19/arch/x86/entry/entry_64.S:
Assembler messages:
/home/joelaf/repo/chromiumos/chromiumos/src/third_party/kernel/v4.19/arch/x86/entry/entry_64.S:1762:
Warning: no instruction mnemonic suffix given and no register operands;
using default for `sysret'
AS      arch/x86/realmode/rm/stack.o
CC      arch/x86/kernel/cpu/microcode/core.o
AR      arch/x86/crypto/built-in.a
CC      mm/filemap.o
CC      arch/x86/entry/vdso/vma.o
arch/x86/entry/entry_64.o: warning: objtool: .entry.text+0x1c2:
unsupported intra-function call
arch/x86/entry/entry_64.o: warning: objtool: If this is a
retpoline, please patch it in with alternatives and annotate it
with ANNOTATE_NOSPEC_ALTERNATIVE.
CC      arch/x86/kernel/cpu/mtrr/mtrr.o
AS      arch/x86/realmode/rm/reboot.o
AS      arch/x86/realmode/rm/wakeup_asm.o
CC      kernel/bpf/core.o
CC      fs/autofs/init.o
CC      arch/x86/realmode/rm/wakemain.o
CC      fs/debugfs/inode.o
CC      arch/x86/realmode/rm/video-mode.o
CC      arch/x86/entry/vsyscall/vsyscall_64.o
/home/joelaf/repo/chromiumos/chromiumos/src/third_party/kernel/v4.19/usr/gen_initramfs_list.sh:
Cannot open
'/home/joelaf/repo/chromiumos/chromiumos/src/third_party/kernel/v4.19/tools/testing/selftests/rcutorture/initrd'
`]

thanks,

 - Joel


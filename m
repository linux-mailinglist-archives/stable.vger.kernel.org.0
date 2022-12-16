Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDF464EB0E
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 12:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiLPL6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 06:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiLPL6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 06:58:50 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2224385F;
        Fri, 16 Dec 2022 03:58:47 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id BC6BF61CCD7B0;
        Fri, 16 Dec 2022 12:58:44 +0100 (CET)
Message-ID: <dc0b1487-04f9-5a2f-e0f8-d157a74b6bcb@molgen.mpg.de>
Date:   Fri, 16 Dec 2022 12:58:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: matroxfb: cannot determine memory size
To:     Helge Deller <deller@gmx.de>
Cc:     "Z. Liu" <liuzx@knownsec.com>, linux-fbdev@vger.kernel.org,
        it+linux-fbdev@molgen.mpg.de, regressions@lists.linux.dev,
        stable@vger.kernel.org
References: <5da53ec5-3a9c-ec87-da20-69f140aaaa6b@molgen.mpg.de>
 <6ef71be5-def9-4578-3f73-c43c35d7e4a9@gmx.de>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <6ef71be5-def9-4578-3f73-c43c35d7e4a9@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Cc: +regressions@, +stable@]

#regzbot ^introduced: 62d89a7d49afe46e6b9bbe9e23b004ad848dbde4


Dear Helge,


Thank you for your prompt reply.

Am 16.12.22 um 00:02 schrieb Helge Deller:
> On 12/15/22 17:39, Paul Menzel wrote:

>> Between Linux 5.10.103 and 5.10.110/5.15.77, matrixfb fails to load.
>>
>> ## Working:
>>
>>      [    0.000000] Linux version 5.10.103.mx64.429 (root@theinternet.molgen.mpg.de) (gcc (GCC) 7.5.0, GNU ld (GNU Binutils) 2.37) #1 SMP Mon Mar 7 16:41:58 CET 2022
>>      [    0.000000] Command line: BOOT_IMAGE=/boot/bzImage-5.10.103.mx64.429 root=LABEL=root ro crashkernel=64G-:256M console=ttyS0,115200n8 console=tty0 init=/bin/systemd audit=0 random.trust_cpu=on systemd.unified_cgroup_hierarchy
>>      […]
>>      [    0.000000] DMI: Dell Inc. PowerEdge R910/0KYD3D, BIOS 2.10.0 08/29/2013
>>      […]
>>      [   48.045530] matroxfb: Matrox MGA-G200eW (PCI) detected
>>      [   48.054675] matroxfb: 640x480x8bpp (virtual: 640x13107)
>>      [   48.059966] matroxfb: framebuffer at 0xC5000000, mapped to 0x00000000ca7238fa, size 8388608
>>
>> ## Non-working:
>>
>> ### 5.10.110
>>
>>      [    0.000000] Linux version 5.10.110.mx64.433 (root@theinternet.molgen.mpg.de) (gcc (GCC) 7.5.0, GNU ld (GNU 
>> Binutils) 2.37) #1 SMP Thu Apr 14 15:28:53 CEST 2022
>>      [    0.000000] Command line: root=LABEL=root ro crashkernel=64G-:256M console=ttyS0,115200n8 console=tty0 init=/bin/systemd audit=0 random.trust_cpu=on systemd.unified_cgroup_hierarchy
>>      […]
>>      [    0.000000] DMI: Dell Inc. PowerEdge R910/0KYD3D, BIOS 2.10.0 08/29/2013
>>      […]
>>      [   35.225987] matroxfb: Matrox MGA-G200eW (PCI) detected
>>      [   35.234088] matroxfb: cannot determine memory size
>>      [   35.238931] matroxfb: probe of 0000:09:03.0 failed with error -1
>>
>> ### 5.15.77
>>
>>      [    0.000000] Linux version 5.15.77.mx64.440 (root@theinternet.molgen.mpg.de) (gcc (GCC) 10.4.0, GNU ld (GNU Binutils) 2.37) #1 SMP Tue Nov 8 15:42:33 CET 2022
>>      [    0.000000] Command line: root=LABEL=root ro crashkernel=64G-:256M console=ttyS0,115200n8 console=tty0 init=/bin/systemd audit=0 random.trust_cpu=on systemd.unified_cgroup_hierarchy
>>      […]
>>      [    0.000000] DMI: Dell Inc. PowerEdge R715/0G2DP3, BIOS 1.5.2 04/19/2011
>>      […]
>>      [    9.436420] matroxfb: Matrox MGA-G200eW (PCI) detected
>>      [    9.444502] matroxfb: cannot determine memory size
>>      [    9.449316] matroxfb: probe of 0000:0a:03.0 failed with error -1
>>
>> We see it on several systems:
>>
>>      $ lspci -nn -s 0a:03.0 # Dell PowerEdge R715
>>      0a:03.0 VGA compatible controller [0300]: Matrox Electronics Systems Ltd. MGA G200eW WPCM450 [102b:0532] (rev 0a)
>>
>>      $ lspci -nn -s 09:03.0 # Dell PowerEdge R910
>>      09:03.0 VGA compatible controller [0300]: Matrox Electronics Systems Ltd. MGA G200eW WPCM450 [102b:0532] (rev 0a)
>>
>> I found some old log from April 2022, where I booted 5.10.109, and the 
>> error is not there, pointing toward the regression to be introduced 
>> between 5.10.109 and 5.10.110.
>>
>> ```
>> $ git log --oneline v5.10.109..v5.10.110 --grep fbdev

[…]

>> ```
>>
>> Is it worthwhile to test commit f8bf19f7f311 (video: fbdev: matroxfb: 
>> set maxvram of vbG200eW to the same as vbG200 to avoid black screen)?
> 
> Yes, it is.
> Please try and report back.
> It seems to be the only relevant patch, and it fits with the name of 
> your card.

I tested Linus’ master with commit 84e57d292203 (Merge tag 
'exfat-for-6.2-rc1' of 
git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/exfat) and the 
error is still there. Reverting commit fixes the issue.

Tested on:

     DMI: Dell Inc. PowerEdge R910/0KYD3D, BIOS 2.10.0 08/29/2013

Current master:

     [   36.221595] matroxfb 0000:09:03.0: vgaarb: deactivate vga console
     [   36.228355] Console: switching to colour dummy device 80x25
     [   36.234069] matroxfb: Matrox MGA-G200eW (PCI) detected
     [   36.239316] PInS memtype = 7
     [   36.242198] matroxfb: cannot determine memory size
     [   36.242209] matroxfb: probe of 0000:09:03.0 failed with error -1

After reverting 62d89a7d49af (video: fbdev: matroxfb: set maxvram of 
vbG200eW to the same as vbG200 to avoid black screen):

     [   38.140763] matroxfb 0000:09:03.0: vgaarb: deactivate vga console
     [   38.148057] Console: switching to colour dummy device 80x25
     [   38.153789] matroxfb: Matrox MGA-G200eW (PCI) detected
     [   38.159042] PInS memtype = 7
     [   38.161953] matroxfb: 640x480x8bpp (virtual: 640x13107)
2022-12-16T12:26:11.301999+01:00 invidia kernel: [   38.167175] 
matroxfb: framebuffer at 0xC5000000, mapped to 0x000000006f41c38c, size 
8388608

>> The master commit 62d89a7d49a was added to v5.18-rc1, and was also 
>> backported to the Linux 5.15 series in 5.15.33.


Kind regards,

Paul

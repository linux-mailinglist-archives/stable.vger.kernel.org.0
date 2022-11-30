Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B2E63E58E
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 00:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiK3Xgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 18:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiK3Xgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 18:36:32 -0500
Received: from smtpauth.rollernet.us (smtpauth.rollernet.us [IPv6:2607:fe70:0:3::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D05EB5
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 15:36:31 -0800 (PST)
Received: from smtpauth.rollernet.us (localhost [127.0.0.1])
        by smtpauth.rollernet.us (Postfix) with ESMTP id 752E1280085F;
        Wed, 30 Nov 2022 15:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aronetics.com;
         h=from:to:cc:references:in-reply-to:subject:date:message-id
        :mime-version:content-type:content-transfer-encoding; s=
        roll2210; t=1669851390; bh=l05O15bATkGXI/wdS+YQr0GOCLlrjcWQYxpQj
        hxqlsA=; b=RvwI1i72/0I8Xx81ohHTX2GClBD1qD1/PDgPHufoSjCJQyBEIC5Ix
        2dHrANxsdOmEa/vlRVzoomNbg0DIJT+4LdxdckqFdgfxFBBSFodseOOEzBg0HbP8
        caeRg8IZaexc+/8ecyVW6zzRUdPfr5VyPPuiF7eY2c7Jgq4Athj5njlS9gX5sk8s
        Cw2qfX0DUXO3dhmRb7SvCd872k3utjq5xHAFxmvb1Q3f9xiM4d4oh6AiWHsc9Tl7
        JzA7tGtsks5HAsUTXIJT5Vd20QE4nrz3IcVHv2CYxprsz2gjxcm7Ng9UtcCQx/CC
        JGyVsG0a7icTwFqmRgdZqSuNJRHur45tg==
From:   "John Aron" <john@aronetics.com>
To:     "'Greg KH'" <greg@kroah.com>
Cc:     "'Mark Salter'" <mark.salter@canonical.com>,
        "'Mark Lewis'" <mark.lewis@canonical.com>,
        <regressions@lists.linux.dev>, <stable@vger.kernel.org>,
        <kernelnewbies@kernelnewbies.org>
References: <041601d90035$4f738de0$ee5aa9a0$@aronetics.com> <Y3/c73nZVdHCBdZo@kroah.com>
In-Reply-To: <Y3/c73nZVdHCBdZo@kroah.com>
Subject: RE: OBJTOOL Build error
Date:   Wed, 30 Nov 2022 18:36:19 -0500
Message-ID: <0be301d90514$9250bd70$b6f23850$@aronetics.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKf6RgJ5J/J2MTr/YB4gdWkzgfzGAHVZOk2rLurDBA=
Content-Language: en-us
X-Rollernet-Modified: Received headers cleared at submission by user request
X-Rollernet-Abuse: Contact abuse@rollernet.us to report. Abuse policy: http://www.rollernet.us/policy
X-Rollernet-Submit: Submit ID 5af.6387e8f4.b628c.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

One C file and a few header files.

Canonical isn't very responsive and I posted this question a few places.
Sorry about the late reply.

John

-----Original Message-----
From: Greg KH <greg@kroah.com> 
Sent: Thursday, November 24, 2022 4:07 PM
On Thu, Nov 24, 2022 at 01:48:08PM -0500, John Aron wrote:
> Hello -
> 
>  
> 
> I have an idea of where to begin: our kernel code compiles and works 
> on Red Hat, CentOS, and Fedora. In Ubuntu 20.04, I have an error.
> 
>  
> 
> root@form:/home/john/thor-linux/Kernel/ubuntu20.04# make
> 
> rmmod: ERROR: Module thor is not currently loaded
> 
> make: [Makefile:7: all] Error 1 (ignored)
> 
> make[1]: Entering directory '/usr/src/linux-headers-5.4.0-131-generic'
> 
>   CC [M]  /home/john/thor-linux/Kernel/ubuntu22.04/thor.o
> 
> /home/john/thor-linux/Kernel/ubuntu22.04/thor.o: warning: objtool:
> _Controller_process_response_map()+0x1b3:    unreachable instruction
> 
>   Building modules, stage 2.
> 
>   MODPOST 1 modules
> 
>   CC [M]  /home/john/thor-linux/Kernel/ubuntu22.04/thor.mod.o
> 
>   LD [M]  /home/john/thor-linux/Kernel/ubuntu22.04/thor.ko
> 
> make[1]: Leaving directory '/usr/src/linux-headers-5.4.0-131-generic'
> 
> make[1]: Entering directory '/usr/src/linux-headers-5.4.0-131-generic'
> 
>   CLEAN   /home/john/thor-linux/Kernel/ubuntu22.04/Module.symvers
> 
> make[1]: Leaving directory '/usr/src/linux-headers-5.4.0-131-generic'
> 
> #@sudo dmesg -C
> 
> #@sudo insmod /usr/local/etc/thor.ko
> 
> filename:       /usr/local/etc/thor.ko
> 
> version:        0.1
> 
> description:    THOR KMOD
> 
> author:         Aronetics
> 
> license:        GPL
> 
> srcversion:     BC856FA85DB2FEFD38A1B2A
> 
> depends:
> 
> retpoline:      Y
> 
> name:           thor
> 
> vermagic:       5.4.0-131-generic SMP mod_unload modversions
> 
> #@sudo dmesg
> 
> root@form:/home/john/thor-linux/Kernel/ubuntu20.04#
> <mailto:root@form:/home/john/thor-linux/Kernel/ubuntu20.04#>
> 
>  
> 
> Every 2.0s: tail -n30 /var/lib/dkms/thor/1.0.1/build/make.log
> 
>  
> 
> DKMS make.log for thor-1.0.1 for kernel 5.4.0-131-generic (x86_64)
> 
> Thu 24 Nov 2022 01:10:33 PM EST
> 
> make: Entering directory '/usr/src/linux-headers-5.4.0-131-generic'
> 
>   CC [M]  /var/lib/dkms/thor/1.0.1/build/thor.o
> 
> /var/lib/dkms/thor/1.0.1/build/thor.o: warning: objtool:
> _Controller_process_response_map()+0x1b3: unreachable instruction
> 
>   Building modules, stage 2.
> 
>   MODPOST 1 modules
> 
>   CC [M]  /var/lib/dkms/thor/1.0.1/build/thor.mod.o
> 
>   LD [M]  /var/lib/dkms/thor/1.0.1/build/thor.ko
> 
> make: Leaving directory '/usr/src/linux-headers-5.4.0-131-generic'
> 
>  
> 
> Is this an error in objtool on Ubuntu within 
> /usr/src/linux-headers-5.4.0-${26-130}/tools/objtool ?

Do you have a pointer to your code anywhere?  Do you have .S files in it, or
is it all C files?

And did you ask the Canonical developers about this?  You should have a
support contract you are paying for with them, so why not use that?

thanks,

greg k-h

_______________________________________________
Kernelnewbies mailing list
Kernelnewbies@kernelnewbies.org
https://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies


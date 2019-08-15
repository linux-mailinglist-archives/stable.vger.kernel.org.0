Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0458E7FD
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 11:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731200AbfHOJUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 05:20:08 -0400
Received: from mga14.intel.com ([192.55.52.115]:43701 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731199AbfHOJUI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 05:20:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 02:20:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,388,1559545200"; 
   d="scan'208";a="377027245"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.6]) ([10.239.13.6])
  by fmsmga006.fm.intel.com with ESMTP; 15 Aug 2019 02:20:03 -0700
Subject: Re: [stable:linux-4.14.y 8386/9999]
 drivers/gpu/drm/i915/gvt/opregion.o: warning: objtool:
 intel_vgpu_emulate_opregion_request()+0xbe: can't find jump dest instruction
 at .text+0x6dd
To:     Greg KH <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, kbuild@01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>
References: <201908120108.9KdVOsTD%lkp@intel.com>
 <CAKwvOd=JpUsD1XDSBzgwDWcAO+1VuGOLjbGNCTFne-WAqjGzXQ@mail.gmail.com>
 <20190812175828.GA13040@kroah.com>
 <CAKwvOd=ORE==PVaXdyUc44CsNp7bShapjaQ00Ej-UA7_r4CWSQ@mail.gmail.com>
 <20190812180958.GA14905@kroah.com>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <7bb8dc1e-54c2-574d-f8b6-02a3b3e288f4@intel.com>
Date:   Thu, 15 Aug 2019 17:20:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190812180958.GA14905@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/13/19 2:09 AM, Greg KH wrote:
> On Mon, Aug 12, 2019 at 11:00:38AM -0700, Nick Desaulniers wrote:
>> On Mon, Aug 12, 2019 at 10:58 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>>> On Mon, Aug 12, 2019 at 10:49:47AM -0700, Nick Desaulniers wrote:
>>>> On Sun, Aug 11, 2019 at 10:08 AM kbuild test robot <lkp@intel.com> wrote:
>>>>> CC: kbuild-all@01.org
>>>>> TO: Daniel Borkmann <daniel@iogearbox.net>
>>>>> CC: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
>>>>> CC: Thomas Gleixner <tglx@linutronix.de>
>>>>>
>>>>> tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
>>>>> head:   3ffe1e79c174b2093f7ee3df589a7705572c9620
>>>>> commit: e28951100515c9fd8f8d4b06ed96576e3527ad82 [8386/9999] x86/retpolines: Disable switch jump tables when retpolines are enabled
>>>>> config: x86_64-rhel-7.6 (attached as .config)
>>>>> compiler: clang version 10.0.0 (git://gitmirror/llvm_project 45a3fd206fb06f77a08968c99a8172cbf2ccdd0f)
>>>>> reproduce:
>>>>>          git checkout e28951100515c9fd8f8d4b06ed96576e3527ad82
>>>>>          # save the attached .config to linux build tree
>>>>>          make ARCH=x86_64
>>>>>
>>>>> If you fix the issue, kindly add following tag
>>>>> Reported-by: kbuild test robot <lkp@intel.com>
>>>>>
>>>>> All warnings (new ones prefixed by >>):
>>>>>
>>>>>     In file included from drivers/gpu/drm/i915/gvt/opregion.c:25:
>>>>>     In file included from drivers/gpu/drm/i915/i915_drv.h:61:
>>>>>     In file included from drivers/gpu/drm/i915/intel_uc.h:31:
>>>>>     In file included from drivers/gpu/drm/i915/i915_vma.h:34:
>>>>>     drivers/gpu/drm/i915/i915_gem_object.h:290:1: warning: attribute declaration must precede definition [-Wignored-attributes]
>>>>>     __deprecated
>>>>>     ^
>>>> Was there another patch that fixes this that should have been
>>>> backported to stable (4.14) along with this?
>>> If this is an issue on the latest 4.14.y tree, please let me know.  Look
>>> at how far back this commit is before getting worried :)
>> patch 8386/9999 ???!!!  Were there exactly 9999 patches backported, or
>> does git stop reporting after 4 digits? "4 digits ought to be enough
>> for anyone!" (except GKH, it would seem ;) ).
> I blame kbuild, every once in a while when it adds something new to its
> system it goes off and does crazy things like this...
>
Hi,

Sorry for causing the misunderstanding, kbuild bot sets bisect range to 
0..9999 in some special cases.

Best Regards,
Rong Chen

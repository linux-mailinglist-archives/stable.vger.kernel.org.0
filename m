Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11EDD5E2E4
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 13:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfGCLiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 07:38:11 -0400
Received: from mga04.intel.com ([192.55.52.120]:24548 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbfGCLiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 07:38:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 04:38:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,446,1557212400"; 
   d="scan'208";a="184728002"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jul 2019 04:38:08 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb: dwc2: use a longer AHB idle timeout in dwc2_core_reset()
In-Reply-To: <CAFBinCD1qj8sNXOK2Pcbz1MAcdvwywPSxQeERNVpmNw=Gmz=Vw@mail.gmail.com>
References: <20190620175022.29348-1-martin.blumenstingl@googlemail.com> <a7647aea-b3e6-b785-8476-1851f50beff1@synopsys.com> <CAFBinCDDyG_CxW+PB_OrUXfy-aDKSoewC2OyCfGh18N=omSgcQ@mail.gmail.com> <CAFBinCD1qj8sNXOK2Pcbz1MAcdvwywPSxQeERNVpmNw=Gmz=Vw@mail.gmail.com>
Date:   Wed, 03 Jul 2019 14:38:07 +0300
Message-ID: <87d0ir4acg.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> On Mon, Jul 1, 2019 at 7:54 PM Martin Blumenstingl
> <martin.blumenstingl@googlemail.com> wrote:
>>
>> On Mon, Jun 24, 2019 at 7:41 AM Minas Harutyunyan
>> <Minas.Harutyunyan@synopsys.com> wrote:
>> >
>> > On 6/20/2019 9:51 PM, Martin Blumenstingl wrote:
>> > > Use a 10000us AHB idle timeout in dwc2_core_reset() and make it
>> > > consistent with the other "wait for AHB master IDLE state" ocurrences.
>> > >
>> > > This fixes a problem for me where dwc2 would not want to initialize when
>> > > updating to 4.19 on a MIPS Lantiq VRX200 SoC. dwc2 worked fine with
>> > > 4.14.
>> > > Testing on my board shows that it takes 180us until AHB master IDLE
>> > > state is signalled. The very old vendor driver for this SoC (ifxhcd)
>> > > used a 1 second timeout.
>> > > Use the same timeout that is used everywhere when polling for
>> > > GRSTCTL_AHBIDLE instead of using a timeout that "works for one board"
>> > > (180us in my case) to have consistent behavior across the dwc2 driver.
>> > >
>> > > Cc: linux-stable <stable@vger.kernel.org> # 4.19+
>> > > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>> > > ---
>> >
>> > Acked-by: Minas Harutyunyan <hminas@synopsys.com>
>> thank you for reviewing this!
>>
>> is there any chance we can get this fix into Linux 5.3? I know that
>> it's too late for 5.2 so I'm fine with skipping that.
> thank you Felipe for queuing this for v5.3!
> for reference, this patch is now in the usb-for-v5.3-part2 tag: [0]
>
>
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git/commit/?h=usb-for-v5.3-part2&id=dfc4fdebc5d62ac4e2fe5428e59b273675515fb2

I'll send pull request soon :-)

-- 
balbi

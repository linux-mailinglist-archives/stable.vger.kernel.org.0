Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D41426A92
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 14:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbhJHMVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 08:21:38 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:58981 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230187AbhJHMVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 08:21:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8683C580FB0;
        Fri,  8 Oct 2021 08:19:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 08 Oct 2021 08:19:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nakato.io; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding:content-type; s=fm2; bh=
        kEPRSs946GBYPNBXQ5nqgrpY4kO95b8VBBcDedB+Mag=; b=I2RwBtRCMc71GdIp
        5/QJdsZU60npx5a7DFlJRfScoDxc5PbcSCik25SSNOtQv4/sSS9BhiWWmB8AXktz
        4QanmQE7j6OroUXBMPenknx6WSNFb2x3TDUSbk10gRKkzmfKAvHbAzQAhpQGWEiG
        AX751tV1W8zhwV7Q6fPWFNluqpsZ/Slz/x2a+nlMGiLUskj4rcnlWTsj8QxxXgl2
        EqIPIrK+k5IPB2HF8/VuTsfbECC9b9yT6Y9x3Gim6+SWMPNnXZdR+wx6Za/Ei284
        Uja7rH9mGw7dypWytxZJTXK/oU5yVBfIH+TDcaESZi1pjCEzlZNAxLy2uUGLdgCQ
        6FQHaA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=kEPRSs946GBYPNBXQ5nqgrpY4kO95b8VBBcDedB+M
        ag=; b=U1EOUiW4tKuUxv39qT+xBw0W4eT7L1VykUTO2O4XnBe29+DQIHaE+GWU0
        Y3qFOCdDKgyqzwvTEZKa/qusKwOtCd4p8iTyBKFLvX54nhN/rPlgbEmuPcaZJJgv
        b2ZFMw81F/9Dx05Cn2M9wpX2+3RyUvyIojj/9cb2YQTzzzSbij7R38/D0WjWUsFc
        u3FCpyU8/pe0Q8FsB6EUmH40VlvBDAjyi7/6s7BWavajCCDf/FZ5X7ELnQYAX0CG
        YkHI4sGNxa9tGTRZYEO+7eVB60nGwJxLjfp1/p5Y6kxg0rTz/8hmpNJj8qjvikCV
        jPWxQ26G9LDJLMAelEDMlJa+cvz0w==
X-ME-Sender: <xms:XjdgYV9w-A-LbUZxIHeoYjD7QyeGsZzkkO7rdVgAe1nW89oizGLgLA>
    <xme:XjdgYZtOR0OKK19Ik0d9MYFPBySk4r9FNLOMP-yXvq_K79cNj6snYw4NQYFj9ster
    Adoomfo839XkwAYUQ>
X-ME-Received: <xmr:XjdgYTASQI7mrOduBKIUIcJrDG_hQm7_4KpXMXV2nnNCdGjfNqEbb0v111jz72p-wm25TqaqBrkNXUoc94frtWLFk-c3ujkyjl2dpEQ0Nrvqa-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddttddggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkfgjfhgggfgtsehtufertddttddvnecuhfhrohhmpefurggthhhi
    ucfmihhnghcuoehnrghkrghtohesnhgrkhgrthhordhioheqnecuggftrfgrthhtvghrnh
    epvefhudehvdeigeegvedtteevueegudfhjeevueetfeefveetieevfeffheeuleeknecu
    ffhomhgrihhnpehgihhthhhusgdrtghomhdpkhgvrhhnvghlrdhorhhgpdhnohhtrdgtrg
    htnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgr
    khgrthhosehnrghkrghtohdrihho
X-ME-Proxy: <xmx:XjdgYZdKwsoS9u81MJhva0OxX4g4DjJcoBbKmXGyCIIuPhEOsHIGAQ>
    <xmx:XjdgYaMwNdW0GY-Xf2n7q_NWcvnh1GN5b6OlfgRNEUMEDurz8EWiKw>
    <xmx:XjdgYbnDgkINrHGPnNytzbvPTBycKMSaWMs0V3lKOQPNm3VAE49yfw>
    <xmx:XjdgYRo_a4lt65_k3Yk5-LzSCmx_LrFXncigvoCjvSbom8s6xJFw6w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 08:19:38 -0400 (EDT)
From:   Sachi King <nakato@nakato.io>
To:     "Limonciello, Mario" <mario.limonciello@amd.com>,
        hdegoede@redhat.com, mgross@linux.intel.com, rafael@kernel.org,
        lenb@kernel.org, Sanket.Goswami@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] platform/x86: amd-pmc: Add alternative acpi id for PMC controller
Date:   Fri, 08 Oct 2021 23:19:35 +1100
Message-ID: <1837953.FDaK0lLtFO@youmu>
In-Reply-To: <609f5254-4527-38b8-3d1d-5cb06791e103@amd.com>
References: <20211002041840.2058647-1-nakato@nakato.io> <909f28e9-245a-df90-52f1-98b0f63a2b3a@amd.com> <609f5254-4527-38b8-3d1d-5cb06791e103@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Friday, 8 October 2021 21:27:15 AEDT Shyam Sundar S K wrote:
> 
> On 10/8/2021 1:30 AM, Limonciello, Mario wrote:
> > 
> > On 10/5/2021 00:16, Shyam Sundar S K wrote:
> >>
> >> On 10/2/2021 9:48 AM, Sachi King wrote:
> >>> The Surface Laptop 4 AMD has used the AMD0005 to identify this
> >>> controller instead of using the appropriate ACPI ID AMDI0005.  Include
> >>> AMD0005 in the acpi id list.
> >>
> >> Can you provide an ACPI dump and output of 'cat /sys/power/mem_sleep'
> > 
> > I had a look through the acpidump listed there and it seems like the PEP
> > device is filled with a lot of NO-OP type of code.  This means the LPS0
> > patch really isn't "needed", but still may be a good idea to include for
> > completeness in case there ends up being a design based upon this that
> > does need it.
> > 
> > As for this one (the amd-pmc patch) how are things working with it? Have
> > you checked power consumption

Using my rather limited plug-in power meter I measure 1w with this patch,
and I've never seen the meter go below this reading, so this may be over
reporting.  Without this patch however the device bounces around 2.2-2.5w.
The device consumes 6w with the display off.

I have not left the device for long periods of time to see what the battery
consumption is over a period of time, however this patch is being carried
in linux-surface in advance and one users suspend power consumption is
looking good.  They have reported 2 hours of suspend without a noticable
power drop from the battery indicator.
https://github.com/linux-surface/linux-surface/issues/591#issuecomment-936891479


> > and verified that the amd_pmc debugfs
> > statistics are increasing?

s0ix_stats included following smu_fw_info below.

> > Is the system able to resume from s2idle?

It does, however additional patches are required to do so without an external
device such as a keyboard.  The power button, lid, and power plug trigger
events via pinctrl-amd.  Keyboard and trackpad go via the Surface EC and
require the surface_* drivers, which do not have wakeup support.

1. The AMDI0031 pinctrl-amd device is setup on Interrupt 7, however the APIC
table does not define an interrupt source override.  Right now I'm not sure
how approach producing a quirk for this.  linux-surface is carrying the hack
described in
https://lore.kernel.org/lkml/87lf8ddjqx.ffs@nanos.tec.linutronix.de/
Also available here:
https://github.com/linux-surface/kernel/commit/25baf27d6d76f068ab8e7cb7a5be33218ac9bd6b

2. pinctrl: amd: Handle wake-up interrupt
https://git.kernel.org/torvalds/c/acd47b9f28e5
Without this patch the device would suspend, but any interrupt via
pinctrl-amd would result in a failed resume, which is every wakeup
souce I know of on this device.

3. pinctrl: amd: disable and mask interrupts on probe
Once I worked out that I needed the patch in 2 above the device gets a lot
of spurious wakeups, largely because Surface devices have a second embedded
controller that wants to wake the device on all sorts of events.  We don't
have support for that, and there were a number of interrupts not configured
by linux that were set enabled, unmasked, and wake in s0i3 on boot.
https://lore.kernel.org/linux-gpio/20211001161714.2053597-1-nakato@nakato.io/T/#t

These three are enough to be able to wake the device via a lid event, or by
changing the state of the power cable.

4. The power button requires another pair of patches.  These are only in the
linux-surface kernel as qzed would like to run them there for a couple of
releases before we propose them upstream.  These patches change the method
used to determine if we should load surfacepro3-button or soc-button-array.
The AMD variant Surface Laptops were loading surfacepro3-button instead
soc-button-array.  They can be seen:
https://github.com/linux-surface/kernel/commit/1927c0b30e5cd95a566a23b6926472bc2be54f42
https://github.com/linux-surface/kernel/commit/ac1a977392880456f61e830a95e368cad7a0fa3f


> Echo-ing to what Mario said, I am also equally interested in knowing the
> the surface devices are able to reach S2Idle.
> 
> Spefically can you check if your tree has this commit?
> https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/commit/?h=for-next&id=9cfe02023cf67a36c2dfb05d1ea3eb79811a8720

My tree currently does not have that one.  I've applied it.

> this would tell the last s0i3 status, whether it was successful or not.
> 
> cat /sys/kernel/debug/amd_pmc/smu_fw_info


=== SMU Statistics ===
Table Version: 3
Hint Count: 1
Last S0i3 Status: Success
Time (in us) to S0i3: 102543
Time (in us) in S0i3: 10790466

=== Active time (in us) ===
DISPLAY  : 0
CPU      : 39737
GFX      : 0
VDD      : 39732
ACP      : 0
VCN      : 0
DF       : 18854
USB0     : 3790
USB1     : 2647

> > /sys/kernel/debug/amd_pmc/s0ix_stats

After two seperate suspends:

=== S0ix statistics ===
S0ix Entry Time: 19022953504
S0ix Exit Time: 19485830941
Residency Time: 9643279

=== S0ix statistics ===
S0ix Entry Time: 21091709805
S0ix Exit Time: 21586928064
Residency Time: 10317047


> > Does pinctrl-amd load on this system? It seems to me that the power
> > button GPIO doesn't get used like normally on "regular" UEFI based AMD
> > systems.  I do see MSHW0040 so this is probably supported by
> > surfacepro3-button and that will probably service all the important events.

We require the first patch listed above to get pinctrl-amd to load on this
system, and the two patches mentioned in 4 so we correctly choose
soc-button-array which is used by all recent Surface devices.





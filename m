Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D26C42758D
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 04:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhJICIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 22:08:02 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:44047 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231947AbhJICIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 22:08:01 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2483C580C3C;
        Fri,  8 Oct 2021 22:06:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 08 Oct 2021 22:06:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nakato.io; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding:content-type; s=fm2; bh=
        3p2CPSrVsa/sq3Kddbr1Xn52lACJl8W9ofjeFGvuyE8=; b=sYlwqnr+vwv7VeOQ
        1izIxeHfT7ZVwCQ3a/hEH6FWVazRMpJn6fPdHrc7AslE1/V1YtlSCWhTpvhiqYnc
        Ls/Q3tQj5j5VTjoVEOEPMOs6yK3mVc6aRBG5syxyoRQ8rqcBkJqXZqY9AGCvv8e6
        1qr6WVKl0DV0IG3d01uTBMQQcYVlef7CrnA5GJQeq8K6wrn55FshqEqG1jOak+v5
        jd4mEIWG//RuFCrcJ4blGtMZAw8m9RY2qUJtWho/0tFLZSWgIvsDQ2UzN8sOkVq5
        QrtuH4wg+cuMpkGie+F/3EKR5re9JJBlZQ+4mjwaRId4G1nt/Fk5PS/5g7G0ZfaM
        hvuelQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=3p2CPSrVsa/sq3Kddbr1Xn52lACJl8W9ofjeFGvuy
        E8=; b=J97ZIbZCvHLpVrqO6GTRGBJ/lMyhSFqNLOmHFNYBArD9MXQGWLGe7FMs/
        cWz1DC+ermDxujqTPw/aoeskd9yoyBxkzzevkUKl62Hukm5bynplFm3rNR8MvKZX
        qHAw3y3Gj855kovwP3ocweyFGlyOO6mgo+c5qfpmZzvvqoNg1evIdBsKZgC0017y
        SqeC7kBDtAbTAV4RGMgkFTSiftIAFSYhBtLurdqeeLwdFewc48fHItF09K/poiFZ
        pzQtPEyBhLhA+1N80p25K5Uc3v1dbUTtuLzJOQ3nZ888xPShVsTrXBLQqAzEij8f
        JXu8Zs/9EhHAtb9UBUZDET4w0dKhg==
X-ME-Sender: <xms:DPlgYSUVdcgt3F1vkUhGwBFN7GvITm9QUJbaoDh-YYGahqdC0PNJcA>
    <xme:DPlgYela62a7LeFP-c7vgJD54VrOA0gh7UMmcHdJRRnKXs_b9ygSg3gteFWaBErC0
    TIIl7GK06jfgkU9tQ>
X-ME-Received: <xmr:DPlgYWZjDxoOI63b_mc4Grevo845HWC3xMgykhgBBBPekmGnaKCLBV94waJWuFGB6HEUJNWKAYFGSmLJcXKAopjhq2GUnILvFXH6RgxS6bvy4bA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtuddgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkfgjfhgggfgtsehtufertddttddvnecuhfhrohhmpefurggthhhi
    ucfmihhnghcuoehnrghkrghtohesnhgrkhgrthhordhioheqnecuggftrfgrthhtvghrnh
    epffekfeehteehffelgfefgeevfeevffegleehuedtkeeuhffgieefhffhjeffgeffnecu
    ffhomhgrihhnpehouhhtlhhoohhkrdgtohhmpdhkvghrnhgvlhdrohhrghdpghhithhhuh
    gsrdgtohhmpdhnohhtrdgtrghtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepnhgrkhgrthhosehnrghkrghtohdrihho
X-ME-Proxy: <xmx:DPlgYZVixkZ3FjACWeun_i3VnVKn91icQ5Xko4fRE1lLWFmlAGji1w>
    <xmx:DPlgYcmbqbL13tKVrICxmxuDLD8zkkRMvlwSmYo9M4A4tzrKqWW6PA>
    <xmx:DPlgYeeGYOA0dCyQqSE8YR4wtfDyQn3EkxnhgIiI_Xja_-ljWTv81Q>
    <xmx:DflgYZhSvS1300UqUaPmJRlnLxIAgnz0B5QaWa7BgCy-WeOwvoPcrA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 22:06:01 -0400 (EDT)
From:   Sachi King <nakato@nakato.io>
To:     hdegoede@redhat.com, mgross@linux.intel.com, rafael@kernel.org,
        lenb@kernel.org, Sanket.Goswami@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] platform/x86: amd-pmc: Add alternative acpi id for PMC controller
Date:   Sat, 09 Oct 2021 13:05:58 +1100
Message-ID: <5824654.09FbfXajTC@youmu>
In-Reply-To: <fa761e91-0aa7-d18d-a1ad-17325f419c4c@amd.com>
References: <20211002041840.2058647-1-nakato@nakato.io> <42e9a7d0-536f-bd15-0c4a-071d09195bc2@amd.com> <fa761e91-0aa7-d18d-a1ad-17325f419c4c@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Saturday, 9 October 2021 06:01:53 AEDT Limonciello, Mario wrote:
> On 10/8/2021 10:57, Limonciello, Mario wrote:
> > On 10/8/2021 07:19, Sachi King wrote:
> >> On Friday, 8 October 2021 21:27:15 AEDT Shyam Sundar S K wrote:
> >>>
> >>> On 10/8/2021 1:30 AM, Limonciello, Mario wrote:
> >>>>
> >>>> On 10/5/2021 00:16, Shyam Sundar S K wrote:
> >>>>>
> >>>>> On 10/2/2021 9:48 AM, Sachi King wrote:
> >>>>>> The Surface Laptop 4 AMD has used the AMD0005 to identify this
> >>>>>> controller instead of using the appropriate ACPI ID AMDI0005.  
> >>>>>> Include
> >>>>>> AMD0005 in the acpi id list.
> >>>>>
> >>>>> Can you provide an ACPI dump and output of 'cat /sys/power/mem_sleep'
> >>>>
> >>>> I had a look through the acpidump listed there and it seems like the 
> >>>> PEP
> >>>> device is filled with a lot of NO-OP type of code.  This means the LPS0
> >>>> patch really isn't "needed", but still may be a good idea to include 
> >>>> for
> >>>> completeness in case there ends up being a design based upon this that
> >>>> does need it.
> >>>>
> >>>> As for this one (the amd-pmc patch) how are things working with it? 
> >>>> Have
> >>>> you checked power consumption
> >>
> >> Using my rather limited plug-in power meter I measure 1w with this patch,
> >> and I've never seen the meter go below this reading, so this may be over
> >> reporting.  Without this patch however the device bounces around 
> >> 2.2-2.5w.
> >> The device consumes 6w with the display off.
> >>
> >> I have not left the device for long periods of time to see what the 
> >> battery
> >> consumption is over a period of time, however this patch is being carried
> >> in linux-surface in advance and one users suspend power consumption is
> >> looking good.  They have reported 2 hours of suspend without a noticable
> >> power drop from the battery indicator.
> >>
> >>
> > 
> > Thanks, in that case this is certainly part of what you'll need and it 
> > sounds like you're on the right train as it pertains to the wakeup sources.
> > 
> > For both patches in this series:
> > 
> > Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
> > 
> >>
> >>>> and verified that the amd_pmc debugfs
> >>>> statistics are increasing?
> >>
> >> s0ix_stats included following smu_fw_info below.
> >>
> >>>> Is the system able to resume from s2idle?
> >>
> >> It does, however additional patches are required to do so without an 
> >> external
> >> device such as a keyboard.  The power button, lid, and power plug trigger
> >> events via pinctrl-amd.  Keyboard and trackpad go via the Surface EC and
> >> require the surface_* drivers, which do not have wakeup support.
> >>
> >> 1. The AMDI0031 pinctrl-amd device is setup on Interrupt 7, however 
> >> the APIC
> >> table does not define an interrupt source override.  Right now I'm not 
> >> sure
> >> how approach producing a quirk for this.  linux-surface is carrying 
> >> the hack
> >> described in
> >> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F87lf8ddjqx.ffs%40nanos.tec.linutronix.de%2F&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=5dWwpgh%2FRIA%2F57UpY5h0l9Snzem%2BNpirgE6ujEHO7aY%3D&amp;reserved=0 
> >>
> >> Also available here:
> >> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Flinux-surface%2Fkernel%2Fcommit%2F25baf27d6d76f068ab8e7cb7a5be33218ac9bd6b&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=HPZfqPoVUJT8w%2FRD7UaVjegT0iRLDlRkXfOwMx5HS8Q%3D&amp;reserved=0 
> >>
> >>
> >> 2. pinctrl: amd: Handle wake-up interrupt
> >> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Ftorvalds%2Fc%2Facd47b9f28e5&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=gUtHcFKolVIZeHtIIJuT3BkruQbjq8NAOU5504%2F02Mg%3D&amp;reserved=0 
> >>
> >> Without this patch the device would suspend, but any interrupt via
> >> pinctrl-amd would result in a failed resume, which is every wakeup
> >> souce I know of on this device.
> > 
> > Yes that was the same experience a number of us had on other AMD based 
> > platforms as well which led to this patch being submitted.
> > 
> >>
> >> 3. pinctrl: amd: disable and mask interrupts on probe
> >> Once I worked out that I needed the patch in 2 above the device gets a 
> >> lot
> >> of spurious wakeups, largely because Surface devices have a second 
> >> embedded
> >> controller that wants to wake the device on all sorts of events.  We 
> >> don't
> >> have support for that, and there were a number of interrupts not 
> >> configured
> >> by linux that were set enabled, unmasked, and wake in s0i3 on boot.
> >> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flinux-gpio%2F20211001161714.2053597-1-nakato%40nakato.io%2FT%2F%23t&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=mwJgcXBY9zdlTG671KssViHdSwHfq6DCJ2fpeLbRbR4%3D&amp;reserved=0 
> >>
> > 
> > We'll have to take a look at this to make sure it's not causing a 
> > regression for the other platforms the original patch helped.  If it 
> > does, then we'll need some sort of other messaging to accomplish this 
> > for the surface devices.
> > 
> >>
> >> These three are enough to be able to wake the device via a lid event, 
> >> or by
> >> changing the state of the power cable.
> >>
> >> 4. The power button requires another pair of patches.  These are only 
> >> in the
> >> linux-surface kernel as qzed would like to run them there for a couple of
> >> releases before we propose them upstream.  These patches change the 
> >> method
> >> used to determine if we should load surfacepro3-button or 
> >> soc-button-array.
> >> The AMD variant Surface Laptops were loading surfacepro3-button instead
> >> soc-button-array.  They can be seen:
> >> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Flinux-surface%2Fkernel%2Fcommit%2F1927c0b30e5cd95a566a23b6926472bc2be54f42&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=PGWON0kCpByJtsO1rS9wrYr7oH86V%2F8M%2FYLmUoFjBhM%3D&amp;reserved=0 
> >>
> >> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Flinux-surface%2Fkernel%2Fcommit%2Fac1a977392880456f61e830a95e368cad7a0fa3f&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=B%2BBW3M4L5TLCq3Fc6oB0KHaC9A%2FQp3uwkB2Jby%2FdDo8%3D&amp;reserved=0 
> >>
> >>
> >>
> >>> Echo-ing to what Mario said, I am also equally interested in knowing the
> >>> the surface devices are able to reach S2Idle.
> >>>
> >>> Spefically can you check if your tree has this commit?
> >>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fpdx86%2Fplatform-drivers-x86.git%2Fcommit%2F%3Fh%3Dfor-next%26id%3D9cfe02023cf67a36c2dfb05d1ea3eb79811a8720&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=XdRCk8klBuDRCk7UWL%2Ft5wiupVVgdCWBqFmaYgGK%2BFU%3D&amp;reserved=0 
> >>>
> >>
> >> My tree currently does not have that one.  I've applied it.
> > 
> > You should look through all the other amd-pmc patches that have happened 
> > as well in linux-next, it's very likely some others will make sense too 
> > for you to be using and testing with.
> > 
> >>
> >>> this would tell the last s0i3 status, whether it was successful or not.
> >>>
> >>> cat /sys/kernel/debug/amd_pmc/smu_fw_info
> >>
> >>
> >> === SMU Statistics ===
> >> Table Version: 3
> >> Hint Count: 1
> >> Last S0i3 Status: Success
> >> Time (in us) to S0i3: 102543
> >> Time (in us) in S0i3: 10790466
> >>
> >> === Active time (in us) ===
> >> DISPLAY  : 0
> >> CPU      : 39737
> >> GFX      : 0
> >> VDD      : 39732
> >> ACP      : 0
> >> VCN      : 0
> >> DF       : 18854
> >> USB0     : 3790
> >> USB1     : 2647
> >>
> >>>> /sys/kernel/debug/amd_pmc/s0ix_stats
> >>
> >> After two seperate suspends:
> >>
> >> === S0ix statistics ===
> >> S0ix Entry Time: 19022953504
> >> S0ix Exit Time: 19485830941
> >> Residency Time: 9643279
> >>
> >> === S0ix statistics ===
> >> S0ix Entry Time: 21091709805
> >> S0ix Exit Time: 21586928064
> >> Residency Time: 10317047
> >>
> >>
> > 
> > Yeah these look good, thanks.
> > 
> >>>> Does pinctrl-amd load on this system? It seems to me that the power
> >>>> button GPIO doesn't get used like normally on "regular" UEFI based AMD
> >>>> systems.  I do see MSHW0040 so this is probably supported by
> >>>> surfacepro3-button and that will probably service all the important 
> >>>> events.
> >>
> >> We require the first patch listed above to get pinctrl-amd to load on 
> >> this
> >> system, and the two patches mentioned in 4 so we correctly choose
> >> soc-button-array which is used by all recent Surface devices.
> >>
> >>
> >>
> >>
> > 
> 
> Sachi,
> 
> I was talking to some internal folks about this patch.  We had one more 
> thought - can you please put into a Github gist (or somewhere 
> semi-permanent) the output of:
> 
> # cat /sys/kernel/debug/dri/0/amdgpu_firmware_info
> 
> That way we know more about the FW versions on your system in case of 
> any future regressions stemming from this.
> 
> Hans,
> 
> If you can pick up the tag:
> 
> Link: 
> https://github.com/linux-surface/acpidumps/tree/master/surface_laptop_4_amd
> 
> as well as that value for "Link: <url>" pointing to amdgpu_firmware_info 
> in the commit message.  Or if you want Sachi to re-spin to do 
> themselves, then Sachi feel free to add my Reviewed-by tag in your v2.

Hans,

The  requested amdgpu_firmware_info
Link:
https://gist.github.com/nakato/2a1a7df1a45fe680d7a08c583e1bf863

If you want me to re-spin with with the these two links and Mario's 
Reviewed-by tag, let me know.

Thanks





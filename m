Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D876E287192
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 11:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgJHJcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 05:32:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729068AbgJHJcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 05:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602149517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iuEuaaaqpVwlqOsJrPgjQ2utMxUzJtKZfAzvt/ouAzY=;
        b=NdQyibGRJULhglTNMP3GL2iBhZ5nMJVIvgKGefXxLRDLFE0QIPDYnua9Gj6nLom9KZYDb4
        +en0k9gXX8urg2UwufOPiry9r1L54eqeRDVASMBrPA+BtkZ7Y1MvL4wuJhQuWLOlNl1JIU
        qPu/J/RcRCgLqanW5jJJKqp35Xi4a98=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-JqPeGC5-MJ6LUCvXKngGBQ-1; Thu, 08 Oct 2020 05:31:53 -0400
X-MC-Unique: JqPeGC5-MJ6LUCvXKngGBQ-1
Received: by mail-ej1-f71.google.com with SMTP id t1so1976557ejb.21
        for <stable@vger.kernel.org>; Thu, 08 Oct 2020 02:31:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=iuEuaaaqpVwlqOsJrPgjQ2utMxUzJtKZfAzvt/ouAzY=;
        b=UvHUwNXVOJ4rPEozVKw6Fmx+//JlqWrwNs3datnf17e1a1knji9tmyG0bBlAWdyj5S
         M3q33uXPpywgzD5Dx/1gDuNRpLVfShXGEZPE3V9PTEshPPvL3uKo5g/760WmxKIMjA+G
         kd4UHobv0hamSec7rr90OQtTMTOArXOaUByw89j4ZYOY9qSHJJAdz7xEeQX0CkE5zKF1
         BFs6iNcchVuWTiGPSmrWjaivFUQ/PsKjWcyH5Em0gwl0DY/YscnhBuuD9u/ICMRl5rV+
         wAMg9ga2/s5SyEAOL1HQvY3R1FGvaWpvRQoaNSThRke4k7aObCUb2uoJkKkWu4chBs6P
         Tvnw==
X-Gm-Message-State: AOAM533IQfX1N659n54Ii6WawDzXpbfL7q3l1ZUroXSq+S8IO0N50xvJ
        vTJ/qKzuerSmfnS/mQ4HodLL5CAT2C2DTPx8ZZJXPoGCsxHFtAF9zkcxk3myx38d80PUR0HxPDp
        aiyRgwwmPYQvrefUV
X-Received: by 2002:a17:906:5008:: with SMTP id s8mr8077522ejj.408.1602149512117;
        Thu, 08 Oct 2020 02:31:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynZ1ZFUvRW5ijerVhv6HluCBrdVk9Frq36pzzYMEjnBtJQuXASBiIsOHScf4o0EPTGkt2mvQ==
X-Received: by 2002:a17:906:5008:: with SMTP id s8mr8077505ejj.408.1602149511816;
        Thu, 08 Oct 2020 02:31:51 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id u16sm212766ejz.43.2020.10.08.02.31.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:31:51 -0700 (PDT)
Subject: Re: [PATCH v2] pinctrl: cherryview: Ensure _REG(ACPI_ADR_SPACE_GPIO,
 1) gets called
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-gpio@vger.kernel.org,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>
References: <20200504145957.480418-1-hdegoede@redhat.com>
 <20200506064057.GU487496@lahna.fi.intel.com>
 <f7ebb693-94ec-fd9f-c0a8-cfe8f9d4e9bf@redhat.com>
 <20200507123025.GR487496@lahna.fi.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <3d7ce79f-6157-8ae0-dae9-ebc940120487@redhat.com>
Date:   Thu, 8 Oct 2020 11:31:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200507123025.GR487496@lahna.fi.intel.com>
Content-Type: multipart/mixed;
 boundary="------------635C29E1705C3F6BE86D86DF"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------635C29E1705C3F6BE86D86DF
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 5/7/20 2:30 PM, Mika Westerberg wrote:
> On Thu, May 07, 2020 at 12:15:09PM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 5/6/20 8:40 AM, Mika Westerberg wrote:
>>> +Rafael and ACPICA folks.
>>>
>>> On Mon, May 04, 2020 at 04:59:57PM +0200, Hans de Goede wrote:
>>>> On Cherry Trail devices there are 2 possible ACPI OpRegions for
>>>> accessing GPIOs. The standard GeneralPurposeIo OpRegion and the Cherry
>>>> Trail specific UserDefined 0x9X OpRegions.
>>>>
>>>> Having 2 different types of OpRegions leads to potential issues with
>>>> checks for OpRegion availability, or in other words checks if _REG has
>>>> been called for the OpRegion which the ACPI code wants to use.
>>>>
>>>> The ACPICA core does not call _REG on an ACPI node which does not
>>>> define an OpRegion matching the type being registered; and the reference
>>>> design DSDT, from which most Cherry Trail DSDTs are derived, does not
>>>> define GeneralPurposeIo, nor UserDefined(0x93) OpRegions for the GPO2
>>>> (UID 3) device, because no pins were assigned ACPI controlled functions
>>>> in the reference design.
>>>>
>>>> Together this leads to the perfect storm, at least on the Cherry Trail
>>>> based Medion Akayo E1239T. This design does use a GPO2 pin from its ACPI
>>>> code and has added the Cherry Trail specific UserDefined(0x93) opregion
>>>> to its GPO2 ACPI node to access this pin.
>>>>
>>>> But it uses a has _REG been called availability check for the standard
>>>> GeneralPurposeIo OpRegion. This clearly is a bug in the DSDT, but this
>>>> does work under Windows.
>>>
>>> Do we know why this works under Windows? I mean if possible we should do
>>> the same and I kind of suspect that they forcibly call _REG in their
>>> GPIO driver.
>>
>> Windows has its own ACPI implementation, so it could also be that their
>> equivalent of the:
>>
>>          status = acpi_install_address_space_handler(handle, ACPI_ADR_SPACE_GPIO,
>>                                                      acpi_gpio_adr_space_handler,
>>                                                      NULL, achip);
>>
>> Call from drivers/gpio/gpiolib-acpi.c indeed always calls _REG on the handle
>> without checking that there is an actual OpRegion with a space-id
>> of ACPI_ADR_SPACE_GPIO defined, as the ACPICA code does.  Note that the
>> current ACPICA code would require significant rework to allow this, or
>> it would need to add a _REG call at the end of acpi_install_address_space_handler(),
>> potentially calling _REG twice in many cases.
> 
> I actually think this is the correct solution. Reading ACPI spec it say
> this:
> 
>    Once _REG has been executed for a particular operation region,
>    indicating that the operation region handler is ready, a control
>    method can access fields in the operation region
> 
> You can interpret it so that _REG gets called when operation region
> handler is ready. It does not say that there needs to be an actual
> operation region even though the examples following all have operation
> region.
> 
> I wonder what our ACPICA gurus think about this? Rafael, Bob, Erik?

I realize that this thread has gone a bit stale (sorry about that)
but I have been working on an ACPICA solution on that, and this works
nicely. It turns out that ACPICA already had code to run the _REG method
unconditionally in some cases, so I've simply extended that to also
apply to GpioOpRegions.

One thing which is open for discussion is if we want to extend this
to more then just GpioOpRegions. For now I've chosen to just extend
the current special handling for EC OpRegions to also apply to
GpioOpRegions which fixes the issue at hand.

I've attached a patch directly against the Linux kernel acpica
copy which fixes this.

Mika (or anyone else reading along who wants to help), I know that
ACPICA patches go upstream through the ACPICA repo, but I'm not
really familiar with there workflow and I'm a bit swamped with
work atm. So I was wondering if you could perhaps convert
this patch to an upstream ACPICA patch and submit it there for me ?

Regards,

Hans




--------------635C29E1705C3F6BE86D86DF
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-ACPICA-Also-handle-orphan-_REG-methods-for-GPIO-OpRe.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ACPICA-Also-handle-orphan-_REG-methods-for-GPIO-OpRe.pa";
 filename*1="tch"

From a2729247cb69707c0244e84cfa4316cffc63b35f Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Wed, 22 Jul 2020 22:22:13 +0200
Subject: [PATCH] ACPICA: Also handle "orphan" _REG methods for GPIO OpRegions

Before this commit acpi_ev_execute_reg_methods() had special handling
to handle "orphan" (no matching OpRegion declared) _REG methods for EC
nodes.

On Intel Cherry Trail devices there are 2 possible ACPI OpRegions for
accessing GPIOs. The standard GeneralPurposeIo OpRegion and the Cherry
Trail specific UserDefined 0x9X OpRegions.

Having 2 different types of OpRegions leads to potential issues with
checks for OpRegion availability, or in other words checks if _REG has
been called for the OpRegion which the ACPI code wants to use.

Except for the "orphan" EC handling, ACPICA core does not call _REG on
an ACPI node which does not define an OpRegion matching the type being
registered; and the reference design DSDT, from which most Cherry Trail
DSDTs are derived, does not define GeneralPurposeIo, nor UserDefined(0x93)
OpRegions for the GPO2 (UID 3) device, because no pins were assigned ACPI
controlled functions in the reference design.

Together this leads to the perfect storm, at least on the Cherry Trail
based Medion Akayo E1239T. This design does use a GPO2 pin from its ACPI
code and has added the Cherry Trail specific UserDefined(0x93) opregion
to its GPO2 ACPI node to access this pin.

But it uses a has _REG been called availability check for the standard
GeneralPurposeIo OpRegion. This clearly is a bug in the DSDT, but this
does work under Windows. This issue leads to the intel_vbtn driver
reporting the device always being in tablet-mode at boot, even if it
is in laptop mode. Which in turn causes userspace to ignore touchpad
events. So iow this issues causes the touchpad to not work at boot.

This commit fixes this by extending the "orphan" _REG method handling
to also apply to GPIO address-space handlers.

Note it seems that Windows always calls "orphan" _REG methods so me
may want to consider dropping the space-id check and always do
"orphan" _REG method handling.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/acpi/acpica/evregion.c | 54 +++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/acpi/acpica/evregion.c b/drivers/acpi/acpica/evregion.c
index 738d4b231f34..21ff341e34a4 100644
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -21,7 +21,8 @@ extern u8 acpi_gbl_default_address_spaces[];
 /* Local prototypes */
 
 static void
-acpi_ev_orphan_ec_reg_method(struct acpi_namespace_node *ec_device_node);
+acpi_ev_execute_orphan_reg_method(struct acpi_namespace_node *device_node,
+				  acpi_adr_space_type space_id);
 
 static acpi_status
 acpi_ev_reg_run(acpi_handle obj_handle,
@@ -684,10 +685,12 @@ acpi_ev_execute_reg_methods(struct acpi_namespace_node *node,
 				     ACPI_NS_WALK_UNLOCK, acpi_ev_reg_run, NULL,
 				     &info, NULL);
 
-	/* Special case for EC: handle "orphan" _REG methods with no region */
-
-	if (space_id == ACPI_ADR_SPACE_EC) {
-		acpi_ev_orphan_ec_reg_method(node);
+	/*
+	 * Special case for EC and GPIO: handle "orphan" _REG methods with
+	 * no region.
+	 */
+	if (space_id == ACPI_ADR_SPACE_EC || space_id == ACPI_ADR_SPACE_GPIO) {
+		acpi_ev_execute_orphan_reg_method(node, space_id);
 	}
 
 	ACPI_DEBUG_PRINT_RAW((ACPI_DB_NAMES,
@@ -760,31 +763,28 @@ acpi_ev_reg_run(acpi_handle obj_handle,
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_ev_orphan_ec_reg_method
+ * FUNCTION:    acpi_ev_execute_orphan_reg_method
  *
- * PARAMETERS:  ec_device_node      - Namespace node for an EC device
+ * PARAMETERS:  device_node     - Namespace node for an ACPI device
+ *              space_id        - The address space ID
  *
  * RETURN:      None
  *
- * DESCRIPTION: Execute an "orphan" _REG method that appears under the EC
+ * DESCRIPTION: Execute an "orphan" _REG method that appears under an ACPI
  *              device. This is a _REG method that has no corresponding region
- *              within the EC device scope. The orphan _REG method appears to
- *              have been enabled by the description of the ECDT in the ACPI
- *              specification: "The availability of the region space can be
- *              detected by providing a _REG method object underneath the
- *              Embedded Controller device."
- *
- *              To quickly access the EC device, we use the ec_device_node used
- *              during EC handler installation. Otherwise, we would need to
- *              perform a time consuming namespace walk, executing _HID
- *              methods to find the EC device.
+ *              within the device's scope. ACPI tables depending on these
+ *              "orphan" _REG methods have been seen for both EC and GPIO
+ *              Operation Regions. Presumably the Windows ACPI implementation
+ *              always calls the _REG method independent of the presence of
+ *              an actual Operation Region with the correct address space ID.
  *
  *  MUTEX:      Assumes the namespace is locked
  *
  ******************************************************************************/
 
 static void
-acpi_ev_orphan_ec_reg_method(struct acpi_namespace_node *ec_device_node)
+acpi_ev_execute_orphan_reg_method(struct acpi_namespace_node *device_node,
+				  acpi_adr_space_type space_id)
 {
 	acpi_handle reg_method;
 	struct acpi_namespace_node *next_node;
@@ -792,9 +792,9 @@ acpi_ev_orphan_ec_reg_method(struct acpi_namespace_node *ec_device_node)
 	struct acpi_object_list args;
 	union acpi_object objects[2];
 
-	ACPI_FUNCTION_TRACE(ev_orphan_ec_reg_method);
+	ACPI_FUNCTION_TRACE(ev_execute_orphan_reg_method);
 
-	if (!ec_device_node) {
+	if (!device_node) {
 		return_VOID;
 	}
 
@@ -804,7 +804,7 @@ acpi_ev_orphan_ec_reg_method(struct acpi_namespace_node *ec_device_node)
 
 	/* Get a handle to a _REG method immediately under the EC device */
 
-	status = acpi_get_handle(ec_device_node, METHOD_NAME__REG, &reg_method);
+	status = acpi_get_handle(device_node, METHOD_NAME__REG, &reg_method);
 	if (ACPI_FAILURE(status)) {
 		goto exit;	/* There is no _REG method present */
 	}
@@ -816,23 +816,23 @@ acpi_ev_orphan_ec_reg_method(struct acpi_namespace_node *ec_device_node)
 	 * with other space IDs to be present; but the code below will then
 	 * execute the _REG method with the embedded_control space_ID argument.
 	 */
-	next_node = acpi_ns_get_next_node(ec_device_node, NULL);
+	next_node = acpi_ns_get_next_node(device_node, NULL);
 	while (next_node) {
 		if ((next_node->type == ACPI_TYPE_REGION) &&
 		    (next_node->object) &&
-		    (next_node->object->region.space_id == ACPI_ADR_SPACE_EC)) {
+		    (next_node->object->region.space_id == space_id)) {
 			goto exit;	/* Do not execute the _REG */
 		}
 
-		next_node = acpi_ns_get_next_node(ec_device_node, next_node);
+		next_node = acpi_ns_get_next_node(device_node, next_node);
 	}
 
-	/* Evaluate the _REG(embedded_control,Connect) method */
+	/* Evaluate the _REG(space_id, Connect) method */
 
 	args.count = 2;
 	args.pointer = objects;
 	objects[0].type = ACPI_TYPE_INTEGER;
-	objects[0].integer.value = ACPI_ADR_SPACE_EC;
+	objects[0].integer.value = space_id;
 	objects[1].type = ACPI_TYPE_INTEGER;
 	objects[1].integer.value = ACPI_REG_CONNECT;
 
-- 
2.28.0


--------------635C29E1705C3F6BE86D86DF--


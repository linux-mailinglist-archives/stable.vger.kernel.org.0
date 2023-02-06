Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A6468C4CB
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 18:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjBFRa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 12:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbjBFRaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 12:30:02 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50B24208;
        Mon,  6 Feb 2023 09:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675704600; x=1707240600;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QAsMTFsaJdOzRntbLKqv/ROETrRC0xz9t0GFNmIdKuA=;
  b=g9WvI+KUiJWJ1Ux3RIDhqyIdE71mD0e9/YPOReuKApOCB1z7HGlAcdkY
   99dwDmHwv12dqpK1MSJdP67BVoLWKxP0LbOVD1hqsxU3nCvF+YA/KTdye
   8TIz2rPRzW+NHmLiHUiBpMv4Gm/3+0AWpXjHVSpDhmEkdA19AHdJiwers
   XCcrXd3sJv+kIoZk86CHxUShaiEp49coUColr3xv/eRxaFxPErP5A37Pg
   0p7v1JRGDR6P064Pt9/kVsXlrBuz9GdoUEMmnPMkNVnvB7/Z+gPvwSEJC
   kycSgbjUal6+oJmsCd43GffWNk+w/rPzcgh6QFqvZhA0mYe4TX7hSzZYe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="393861564"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="393861564"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 09:29:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="755309395"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="755309395"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Feb 2023 09:29:51 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 09:29:50 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 09:29:50 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 09:29:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQ5l/endc1zkCqT4L3h/yFFFaqAEMXisOeYAobNkDKtAGVWj+A1XBoSPeKyXNxjEO9K7E6Ng/Rbw24k6C+K2kN7jh4Nkq8WusjPf4eIslStnnixXfHXXrI+dCx1qLHXnJCKQYdmLnu0JUp2DBo+XhINYeyFd3GfJTX9Z9Pt+WnOjjQqeg1OJv/qYeYh/kMJkEsIL9Dg0SrYMViDXrf1s555ImuCK0sD9ujRiWbmvMrbkFT+fuaLUdDWfU6JHz3uYNbFJ8iNYcQB0q6dPkRikKuifQPfFIvxGXI/wJGZCtzbUEvDHf3md1r4FLw+2ayQoqLmMFlcbHWQJZl6e+l+/VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SZfbs4AaoBFTbQY/sQbr32tjmqr2i+zJ5ZLD571+Gw8=;
 b=bRaqEjiagSuGNQmAkcwuNK6OBn24jiWyPrSH5Fe1QAAGKw/S4HCpZCgHmg5emLh+eSpP5ab4u21dLRjV/zQopftbswrYzCojm/k45cFMM5K8zHs7T814QhC1bXCOqKFfF8NCqNC6bmTj0+R4Ch6/TIw+OFVbv4UW81UVbOUOSoausk7JdZZL8OSPH5Pwu1jVbIfCpg65GPQo9WxgfwbpVVKtCKH6+PQmKGxe1iBV566sMMrOjGdKGtk0lleEl04ODpYxLoDnl4U5fisPYuD4BvQ1PeQteJS8VDx271Thwwg5gDUm/0xRefKw6DsgB1fUXNUyO0n/X3luDX9UoMGkgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB6262.namprd11.prod.outlook.com (2603:10b6:8:a7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 17:29:47 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6064.031; Mon, 6 Feb 2023
 17:29:46 +0000
Date:   Mon, 6 Feb 2023 09:29:43 -0800
From:   Dan Williams <dan.j.williams@intel.com>
To:     Gregory Price <gregory.price@memverge.com>,
        Dan Williams <dan.j.williams@intel.com>
CC:     <linux-cxl@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        "Kees Cook" <keescook@chromium.org>, <stable@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, <linux-mm@kvack.org>,
        <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Message-ID: <63e13907cffb9_ea22229458@dwillia2-xfh.jf.intel.com.notmuch>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
 <Y+CRyz0eFKfERZLD@memverge.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y+CRyz0eFKfERZLD@memverge.com>
X-ClientProxiedBy: SJ0PR03CA0150.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::35) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB6262:EE_
X-MS-Office365-Filtering-Correlation-Id: fd17ebcb-c62a-4c7d-1029-08db0867bd75
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pKGqfS3Jsy7SAvmaAQt2iybEZ1gZKOVtBWtMJp1tWSEsN3LuQflmXxxh5wsfk1InwWMrQrEon7FONP+b9+F+gz9cyhW5yuT8od4bEjhTD30S/mdey0o+A82Ooj5X+c0CrpqEuFIJy3yytUAsKQdOESTTbR8SAS4O7CkablII77KO8Ci7KKjkH+V5sEkcLX36TR036Nzi3RluoO53GG1dala5S+W5hzDy6zM7seItgNgTCKwFsv5lCKSXwL26eTekiwyIwQ+OAXzAH4TFxDvSe0kH3GzYFBQR+odlI4of+vgoAyj42iCvoW3w1UJ3xURuLg36yxwrwo8mS0YI90RG/dTgSDJMVupZrxf4Xz6ochBZ24NE2/zXcZu9okVTf44N+yfH8/n8Ehs6c8npJmgULuIS6JB4RGTob/cqNWT5GavNlxLrjkO/2xmKPnX5An29v8ZqlHt7PZA2yEqfz8nXjFF1jMQIGH6c9l2VyghyxcK3HffV6Yaou4bodTFGa6u3tPnMuIWWrfvd22SbRmmxdF68RNk2d9r6JPwyyAF0kvNUcj49mFaj8g2S8LT32y/sle1idSBsvjSgn9hHNJGiG13AHUatQ4pxrZZiCHtehXNHjNZLJzrir3nqw5Tpi0Gy1/lOpoPD/23r8syDnIug0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(366004)(39860400002)(346002)(396003)(451199018)(86362001)(82960400001)(38100700002)(66476007)(5660300002)(41300700001)(8936002)(8676002)(66556008)(54906003)(316002)(66946007)(110136005)(4326008)(2906002)(6486002)(478600001)(26005)(186003)(6512007)(6666004)(9686003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NRXm1hj2C2zokoU5cwFDzqFnoAV0b9LZIfJ0jEClTpoow4xPjzHVMA1lMmlN?=
 =?us-ascii?Q?ulS2Z2aOo+AekcO2Afi9ZkNWQo3ZFhAr4aTMpWp93yztqTEWvi67ipj45+R5?=
 =?us-ascii?Q?jVWdVjqPYvYwiQZ1/AuPfv/bl4Dl1by5jTpvqmiPGUtvIjNJ/2NnFfS6xSuP?=
 =?us-ascii?Q?1H2OIGoDWN70uC/kg5xdHBL+TswHxPgYP3zrVUQ6TVJxnY0qpFerN6ntNmr3?=
 =?us-ascii?Q?mY1+8BQrAbTejHOKe/wg4tkK+pCHvevMfVwpgHyJytD5/S437SjnfIl5waEQ?=
 =?us-ascii?Q?8WA9P2WRoC0XrjvCJ3YbST4oCt6az6UDDKk12T78GjDNW82uyf4esefKVEGk?=
 =?us-ascii?Q?6pcbJewiWL9y6vHxG4ksIHd+Ggy+qzhXASde5cj64Wx/bla/jLSCZ7aPVt8T?=
 =?us-ascii?Q?uFbNJZ6w+aMzjJsuRlqWe+Bt5sG3DGZ4EptjFoaywn22NNYFaYEDI9TOFqAq?=
 =?us-ascii?Q?gjAvFamX9SFRf7CNYbz6OxUqxVQMgHdnDf6BKurZhJHfNGvwa3ki2itgRa0z?=
 =?us-ascii?Q?5voB0Febr6Cg/fNBMUGIAgIdl3qxjAnqaqOJGaVwA0me2tSf652BLpLsdnpx?=
 =?us-ascii?Q?iuUt1ZoMKNzxyGQrzuB54KFZjsUBTInDyByz2iqOI/R4UnQEC4mBBKOnn9GK?=
 =?us-ascii?Q?HklvssXuimmwjYym2ok4ngrFcxQit5NGb6u5Y95e0aNnGPFoRYbq2CucgL94?=
 =?us-ascii?Q?C1x/v7RPXfWceGFw+iPD2CNjKSvqbHDIBKxBL/ifjwUd3/Nbailcc+00hmPf?=
 =?us-ascii?Q?Is015d0r2IwI8hRNP+G3eEwVLCSQs8aGDxrcZX+ZzAZ6Vvxw+hiXqnrH7JRH?=
 =?us-ascii?Q?s2fAJG11kF0t0NkJnV79KAUJ+vXmabAU7gEHwt/I2HgdkQ3xQAGKllC0AFUx?=
 =?us-ascii?Q?KGpaRX2HElWib9Gz+TtM5S5V9WWc2zNa6Pb0AhU2Q/aWZGxHchZGpeT2DlZH?=
 =?us-ascii?Q?OfNnlMo+yErw+I4KJEZfR+rarUtCwS66r2bovnnH4MfL/cwhGU3/sirF73WS?=
 =?us-ascii?Q?G73TEPssTHxCGH2QHJibPM6dBJ60V0qOlXcCoSgVZ4hjlLGK5Ti/3A9jtQhh?=
 =?us-ascii?Q?R56g/gqsuG7LNd41BoiWeArBqPpIt1lDZIJYtkdyOS4ozq6bbr867lMDLpv+?=
 =?us-ascii?Q?48O1+RWnBsjZSxSCyG/d5UBiP4Z5BBfDW/2sskDYOE+FhbHQSvbCNCIpD16G?=
 =?us-ascii?Q?yfPdYE2ZcXhviEgvYGFEZ5Ybb9jb2Z9iTF16cb/YaZaeHVzPpeR4xvHm7YTl?=
 =?us-ascii?Q?q4MjT3r+I4PsAIeaUw6c8oJH4IYoDE2ItAyQvMTfR2+Ik7Kb3DQaBfaA3Pci?=
 =?us-ascii?Q?87O3QaqHaOEKlV8ktG9ktY5tTbpXX/WGTUL0aiQUFvd2A2GAvKYxiccbmZbX?=
 =?us-ascii?Q?abYz3Ldi8B2zHjPNuxA2zn30YRHrc85IjL1YXmXHOrXMa5na+2MtCgZ8xwW0?=
 =?us-ascii?Q?Rp5untXQqc07B4TxUH0O55dLmpYJo48huVvUdfmlVLupz3SJGAl+joSDtyso?=
 =?us-ascii?Q?X8VWjQ9kwBuXv8wNiAESfWSZ3776bMCxbVJ2HYlEK7Ar88y5Jtl9FSOTbiHa?=
 =?us-ascii?Q?4U/047aJVdf09OUD3uv19PgeBn0Boe/Goa+JcMZVbjGLCpRx6f7ayGV4zI/E?=
 =?us-ascii?Q?Xw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fd17ebcb-c62a-4c7d-1029-08db0867bd75
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:29:45.7839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MSN1r84t7xePl1Tk/onLkZi80Dy0z/luIn8YsIAr1CPzHVWcbTemqXPYDAS/ZTzSVk4K/rvWggZd/cy7APBJsdxn75jWrI8Xj53GeEvdxfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6262
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Gregory Price wrote:
[..]
> Leverage the same QEMU branch, machine, and configuration as my prior
> tests, i'm now experiencing a kernel panic on boot.  Will debug a bit
> in the morning, but here is the stack trace i'm seeing
> 
> Saw this in both 1 and 2 root port configurations
> 
> (note: I also have the region reset issue previously discussed on top of
> your branch).  
> 
> QEMU configuration:
> 
> sudo /opt/qemu-cxl/bin/qemu-system-x86_64 \
> -drive file=/var/lib/libvirt/images/cxl.qcow2,format=qcow2,index=0,media=disk,id=hd \
> -m 2G,slots=4,maxmem=4G \
> -smp 4 \
> -machine type=q35,accel=kvm,cxl=on \
> -enable-kvm \
> -nographic \
> -device pxb-cxl,id=cxl.0,bus=pcie.0,bus_nr=52 \
> -device cxl-rp,id=rp0,bus=cxl.0,chassis=0,port=0,slot=0 \
> -object memory-backend-file,id=mem0,mem-path=/tmp/mem0,size=1G,share=true \
> -device cxl-type3,bus=rp0,volatile-memdev=mem0,id=cxl-mem0 \
> -M cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.size=1G
> 
[..]
> [   15.162837] RIP: 0010:bus_add_device+0x5b/0x150

I suspect cxl_bus_type is not intialized yet. I think this should
address it:

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 0faeb1ffc212..6fe00702327f 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2011,6 +2011,6 @@ static void cxl_core_exit(void)
 	debugfs_remove_recursive(cxl_debugfs);
 }
 
-module_init(cxl_core_init);
+subsys_initcall(cxl_core_init);
 module_exit(cxl_core_exit);
 MODULE_LICENSE("GPL v2");

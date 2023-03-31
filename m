Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504426D1D05
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 11:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjCaJy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 05:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjCaJx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 05:53:57 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05olkn2069.outbound.protection.outlook.com [40.92.89.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01031EFE1
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 02:52:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8fkHqwZwVUOMAqUClFLUqX4OWC6XAcgU4NiFjxnW2erxI34x9c+K5LjUg4BLTlPFLYqKUq8VAxLtxlq3DTSjCRevovozslKDG4MLjaLxIEZKKu5gF3LYPhsR7tJEIPQ6oK1nVao9DqcFJV/QQ2goQ6iRB5AQ3hZcc+UDo2lCI1yluZ9mzfEMFTofyisYnO6/TI+ONDUv2zNK98LfaE25hNdfniptNIzWiMELVFj37KE2usLoht9KuBa1BC0FgedA6ADeHeFhqyBw/2NusK0i0XSQxcV3FJx245wB3nSNMnbzchEjnU1jpUH/G0ENzIaFLY+RtJfms5lFsU1toIH3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vf957+Ef2UW1giVwJXEGaK32zvlnnUqEm0AAQR12HmM=;
 b=d2q65PeEoWqEiUBXtDJqgva4qNcKHxLRACqWz4wG+2Taz+pSHBFk9No+fm0hxTDer1MOTh6KHYVTM1LsN+xrB7Nff0WvPkMjHZqxbL9U5Yr3PYn25crgd8n3dsLv+HD0q1IX6NIUz1AWH9S3QXUuq6Sxtdkrc3YmECmdQeZO0r9pX9S104Wts2bLUARtgDq+o1zJM7WQ/pfZEYQmgnKjaR/50J7LY2+xEu24VnJ+0RRtTi/igC522bZPONkZRnkDv7xpxUSp8O79xWM0AsaNpTjo5KKqJs8ybnjZqTtDITPHBxSr076YV1SCAMtNVMzkk0NqdnDpSlehEK8sm7ZOJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vf957+Ef2UW1giVwJXEGaK32zvlnnUqEm0AAQR12HmM=;
 b=hXuCLPirg3/Wo7p/SR8TJfG7duGJJ4U9T51iy3HhGplowyHCa+j5t+Qyby5E6+EyVgQV1QjmeUwlB2u3l3jnv9xaJO/KDEhKa4WYQbdcrHp3E3JRs5PWtnCXhlm43AYuQAV9ZG3lWrmmzUuDTYmLTRWev1aaYytIRj+KgylymmRcd8u2cRlUXYcuGRxKwdhWe9P3kRMDI+do7w7LrEiRv8UO6hsBg19ZxHKKZyWUkxmtTBE8JXFLctmWnF73PmyuDahhGgcTq8hfES77lJo4oro2Z8DRd4/nrJRc2nGde8dmvrHWsL69SJO6uxEc8jqniMrlrnZS5/1malrdKBYmFw==
Received: from GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:93::14)
 by AS8PR10MB7399.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:614::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.18; Fri, 31 Mar
 2023 09:52:39 +0000
Received: from GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::185f:8a4b:7994:c250]) by GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::185f:8a4b:7994:c250%6]) with mapi id 15.20.6277.014; Fri, 31 Mar 2023
 09:52:39 +0000
Message-ID: <GV1PR10MB6241B5ACB73021007421876DA38F9@GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM>
Subject: Re: linux-5.15.105 broke /dev/sd* naming (probing)
From:   Ilari =?ISO-8859-1?Q?J=E4=E4skel=E4inen?= 
        <ijaaskelainen@outlook.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "linux-stable.git mailing-list" <stable@vger.kernel.org>
Date:   Fri, 31 Mar 2023 12:52:37 +0300
In-Reply-To: <ZCaULkVk6iHHJYm2@kroah.com>
References: <GV1PR10MB62412F2794019C35025C7360A38F9@GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM>
         <ZCaULkVk6iHHJYm2@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-9.el9) 
Content-Transfer-Encoding: 8bit
X-TMN:  [PvwN7cbzS6IUUq74gfCMx5tUFJVZtPsb]
X-ClientProxiedBy: SV0P279CA0015.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:f10:11::20) To GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:150:93::14)
X-Microsoft-Original-Message-ID: <cf4859cad60f690ed8eb182b90898e1322729355.camel@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR10MB6241:EE_|AS8PR10MB7399:EE_
X-MS-Office365-Filtering-Correlation-Id: 418dcbb8-bbb2-4993-9a92-08db31cda9fd
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CB0dECYx0tub+WAiffSjM4kYsUuG6DhHHmyJ2+AKAut9R7wRNw+ifmXI3mB1t3X7vSVmYJKtguAqGol5S8yzcg+b2ly9vfeHn+6NGe4XfaC7//g0whGRLWY7mKQyaGuvBQjJ8ouUTrEmthkf2rez+MpeovjPyk8Kg8p+/04/fl4smov9FIycNl/VGldj/CkKMoNqUjMzDVAW+eQ5s9YRkqfz9RishGEKqGe6sVbiOvODtNXphaFzOlnPzfFZ5El+m46x13Tw+P6X/1wrzzXEi16emy26dMJ1Pa9zPbtqi3BVayOfMDAGbWgZfhfbZPNjR23ZJMCnH/zKpF4fQvKEuNCKh4UtFRriO0Y4JB0nkRHUPVBTJZuEEgPDOTDHSK1gbrjQxzP094khS5VpI6hhp67iPEk/IvAueuDma1kU8qlIcu7EdSXMbQ6yITHw1iKBAgeDYl16Hs2AP2LFNpY/dSd62JQKCVtf3UJKUYA2A6XsorbtaCXFeaCSLiZn1schuiCQd91UoSqHkErIhJze+BuZ2N6H2DfjLUSf7SWUrvB0a53mAT8UV/RcOmuRQ8sBubwwhzcWMDQA7/uVPLXkG1IgFyHXkQCIWn9KTv5Tk70aLUc5XHWi8FyCz1DRvc2j
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2RraFdpU2ZzNE1Rb2Zib1c4VjJ1dStieDJHaEJxOGNsQ1NzenZncFZaVjh2?=
 =?utf-8?B?ekdOY1Rid2VtZThrV0Q3bE1rNk4raXhhbDkwbmFPUmhIbE41Uy9aUEgrTlo0?=
 =?utf-8?B?d3dOb0I5Smp4bERzOUVUVFE4U2JXYmY4d2RVZWJQRlB6QmRvZHNrcXdDc0tn?=
 =?utf-8?B?SUE3cVQ5Z1BMNWpQTSt2S0xCNzhrckJKSzZ3ZmxHQlZURDlQOGZjYkxxS3c1?=
 =?utf-8?B?bTF0VGQ5NGNqU3lrNGNoNllpdkx0WDRsOWhPeUJhYjgvMzVZTTJYWkxWOGNw?=
 =?utf-8?B?d0g0TGRURWFDZlNaTjdTdWpaSTlUVGtqWW55aUd6Ymt3YzI4WklZMi9ZLzBH?=
 =?utf-8?B?MldDM2cwS2hQM2VNTHlhdnJFQVU0VWpwdzV3eVcxaElpbFVqTnVZNUpvUHA3?=
 =?utf-8?B?bG14M1B6SjF0eTNxU2IrbjFEdFc3OFV3Tkx6WmF3YkJKSGxlOURIOVpPbDA2?=
 =?utf-8?B?cmM2Z2YzUkNuaFhXRkpUMEx6TFZ3T1M5TDk5MUxGZ0NWS2o0OXdUQ2xXYmpx?=
 =?utf-8?B?M3dpc00wemRGa1h3ZmtCaFZlNy81L09RN2duVkJaeXkrQXRVQzlRNjdwT1oz?=
 =?utf-8?B?bEFMUnpKVUxFZnd6Wm1XR0xRSjJic3pjV0RubE1WakVoL1QvZC9hMzVqalJW?=
 =?utf-8?B?bmNoUkQ3dXBKc0hPNG9XZ21qcGhVdEhNUXJ1ZDRjNGRKSHJKcFNRWVE2cXpR?=
 =?utf-8?B?b2p3SlVjS0R6MmcxZDc3RlBIeEZsWWp1dWRkcVpzSmVJbkh1Z0c4aDF4QTIy?=
 =?utf-8?B?NjBNZ0VXbHBTa0R1bTRyVUprL0YwZWZwZldHT3lveE4ya1JhRUhyeUlOa2t0?=
 =?utf-8?B?NUhyWEtURkEvdmx2ZmVOL3NWdXh0V051M0xyZEk0ZEhMQVV0OTZCNzg4RHQv?=
 =?utf-8?B?bkFxZEE4WkJpVjdSU3BFeE9ZR0hER0IxK0xWeDREMXhRRSs3Um5qOHdvd0Fl?=
 =?utf-8?B?Z00yaDcrK0F6UTB3cE1PZGNzSXNGT2o4QzhIUDVXd2FyOW5vWU9Ob2VNUC9U?=
 =?utf-8?B?ZjhrYkprVEJnMk9JWWJXaVM1b1JSSUZnM1pkNU9wVW4rWVp5WThtYjM4Q0t0?=
 =?utf-8?B?SjVpbWFFeU1ZZEd4a29nOHV0S2drcEkvSDl6Vnk3b3BaNHFRZzVTZnJlVWUx?=
 =?utf-8?B?bWRFRUdRVUx3K3dudEtKNjZ4QUlBajFOLzlmc3gxT2Nubjc3U21rajdwdmFw?=
 =?utf-8?B?WFM3Y1FWSVIyYVdFSm1zdC81aFRzREE1bVFZVGNRRXQyZ2JSVmppNGJSTzFG?=
 =?utf-8?B?YVZSRGVxY3BmcFpPQTZDOGdtV0dDZ04yc0dwa3EwemNXcWFEZUtPWUVKYlFT?=
 =?utf-8?B?blBrTWtuMGw5czdPOFdvaFEwZW1RZk9PTkVoSDBwV3NnQVNVVlhSZjRhdFJy?=
 =?utf-8?B?V29hZ1hrS1ZQUUdXb2Q2NHR5NmxWZ1RJajNDMnoxTlhUM3ZUWlVpRUhMbEJ3?=
 =?utf-8?B?VUJNQXBrZUhzTUR3Q2UxL0h1N2xYME8vUmF1Ymt6dXE4OGtabzJqZnNzZFhQ?=
 =?utf-8?B?aENoNVh0bG01eUZMOFFQaVhpYW5sS0J3dFJoVWd0cEt1aEJjQzcwUGhpMGFQ?=
 =?utf-8?B?U2R1QXdjWGhUYU5vU2FpWTI5UzNTSXU4M3IxWkdRSThiVDM1L0d3VXQ1S2I1?=
 =?utf-8?Q?4K2YxJIxzfwac6ZEtX6nyau35xzRehBlQZrnNWuiWOyI=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 418dcbb8-bbb2-4993-9a92-08db31cda9fd
X-MS-Exchange-CrossTenant-AuthSource: GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 09:52:39.5205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR10MB7399
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here is the output of dmesg without doing anything with the disk:

[ 7632.544792] usb 2-2: new SuperSpeed USB device number 2 using
xhci_hcd
[ 7632.575851] usb 2-2: New USB device found, idVendor=152d,
idProduct=b567, bcdDevice= 2.23
[ 7632.575856] usb 2-2: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[ 7632.575858] usb 2-2: Product: USB3.0 to SATA adapter
[ 7632.575860] usb 2-2: Manufacturer: JMicron
[ 7632.575861] usb 2-2: SerialNumber: 0000AB123531
[ 7632.636013] usbcore: registered new interface driver usb-storage
[ 7632.655897] scsi host4: uas
[ 7632.656277] usbcore: registered new interface driver uas
[ 7632.656480] scsi 4:0:0:0: Direct-Access     Samsung  SSD 860 EVO
500G 0223 PQ: 0 ANSI: 6
[ 7632.657492] sd 4:0:0:0: Attached scsi generic sg2 type 0
[ 7632.657753] sd 4:0:0:0: [sdb] Spinning up disk...
[ 7633.694677] ...ready
[ 7635.775548] sd 4:0:0:0: [sdb] 976773168 512-byte logical blocks:
(500 GB/466 GiB)
[ 7635.775551] sd 4:0:0:0: [sdb] 4096-byte physical blocks
[ 7635.775707] sd 4:0:0:0: [sdb] Write Protect is off
[ 7635.775710] sd 4:0:0:0: [sdb] Mode Sense: 53 00 00 08
[ 7635.776003] sd 4:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 7635.776308] sd 4:0:0:0: [sdb] Optimal transfer size 33553920 bytes
not a multiple of physical block size (4096 bytes)
[ 7635.783827]  sdb: sdb1
[ 7635.786814] sd 4:0:0:0: [sdb] Attached SCSI disk
[ 7636.072316] EXT4-fs (sdb1): mounting ext2 file system using the ext4
subsystem
[ 7636.076261] EXT4-fs (sdb1): warning: mounting unchecked fs, running
e2fsck is recommended
[ 7636.083896] EXT4-fs (sdb1): mounted filesystem without journal.
Opts: errors=remount-ro. Quota mode: none.

The original fs of the SATA-III SSD used to be xfs, which I changed to
ext2 in hope it would fix the problem about "I/O-errors", but it didnt.

pe, 2023-03-31 kello 10:05 +0200, Greg KH kirjoitti:
> On Fri, Mar 31, 2023 at 10:52:55AM +0300, Ilari Jääskeläinen wrote:
> > As I attached a USB SSD into CentOS 9 Stream computer, after a short
> > while it swaps /dev/sdb into /dev/sdc and the I/O gets ruined.
> > Kind regards, Ilari Jääskeläinen.
> > 
> 
> Is this using the CentOS kernel, or a kernel.org release?
> 
> And if a device changes names like that, it implies it was disconnected
> and then reconnected, what does the kernel logs say when this happened?
> 
> thanks,
> 
> greg k-h



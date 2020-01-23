Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A140146D4F
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 16:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgAWPuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 10:50:22 -0500
Received: from mail-eopbgr700055.outbound.protection.outlook.com ([40.107.70.55]:1953
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726231AbgAWPuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 10:50:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELWQorFUXO2BZwO/RPWi8a3eJ1EjVA6Yb0CTiPcukBNFgAqoM8t3lu1eBqcppndv2kkpmKNf5NhcS11HLpb2Edwk1bVhFX17ZYaVedzccP92yAUHvLTzobH+KL+EMx4ZkCaIAfE+TPvFARs3N0cRus1SCeq+JsQm+EAGk+PQ07A9/IxIEXWP9Qur5opDjs/exDkueJk4sgjKX/W2LQv5plw2pmMdwgb+Bw40ohIea2pd0AueAZu1N2UVvVYySW06P5yIsj+B7VnmUFKtqzQUAeSNUBw0YX7MrHw3eiEa5vLUBK5DRChF9m9HcHXL2MUzBRF1Bs+tNmJhtNr0DjDiMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+k7sAzfUilNRmOjd15nG+eb/G7NjCwCiCtBlt2XQFcY=;
 b=QdA19/9xesp9loQx6ihJQ6TkIgbbLw/oefjF7rfQ7OzOWcpPngNFVqpBpmuUWUnzjBw0dUFu1q//k1LHGC+1zKMuVwtBd2jLZDqEqp6hREyYXHTMfncc4m83bHMVl+Jjmtoi/uQXmxqWd5UfTdhp1qEJZvq9gdQSUvwJYhljBybEa1Il5WbsuzMrTttT0QoXaIpqJNE5nZRazb3rqaky+EXOZENFGBmBr+s3r9c9c28BcIywmWwLBHbFKfUjGPpYh/JdS7tN6YET676Zdjh+a0ThxgzFpXz6OAbMj1MED3fygp2Dc66RAr5FIP5sBuKU1yYqAvByRQA/OWurxtB9Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+k7sAzfUilNRmOjd15nG+eb/G7NjCwCiCtBlt2XQFcY=;
 b=g9myLG2mY9Rp57fkd8WqGtPx1Z+FoG/aHTtpxaGhT7KKP+PsutqdMtucb6Gq/PuXfooKEgctfgZLbrV2vYy4PAx4Sv2v/Q/WFZqzC3ppZs1HEqL6WGyMkQZhFf5/Cr7VemchSMNIrR3CMB5N+UlZkSFwShJbd9Xj0szi9lpUiz8=
Received: from BYAPR02MB5591.namprd02.prod.outlook.com (20.178.1.29) by
 BYAPR02MB5719.namprd02.prod.outlook.com (20.179.63.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Thu, 23 Jan 2020 15:50:17 +0000
Received: from BYAPR02MB5591.namprd02.prod.outlook.com
 ([fe80::1098:89a8:aca6:2182]) by BYAPR02MB5591.namprd02.prod.outlook.com
 ([fe80::1098:89a8:aca6:2182%5]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 15:50:17 +0000
From:   Anurag Kumar Vulisha <anuragku@xilinx.com>
To:     Felipe Balbi <balbi@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
CC:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: RE: [RFC][PATCH 2/2] usb: dwc3: gadget: Correct the logic for finding
 last SG entry
Thread-Topic: [RFC][PATCH 2/2] usb: dwc3: gadget: Correct the logic for
 finding last SG entry
Thread-Index: AQHV0XMN2JE5ah6oJk6eG1ETCoXb16f32boAgACCGIA=
Date:   Thu, 23 Jan 2020 15:50:17 +0000
Message-ID: <BYAPR02MB55910511FDAA7FDA0C647ABEA70F0@BYAPR02MB5591.namprd02.prod.outlook.com>
References: <20200122222645.38805-1-john.stultz@linaro.org>
 <20200122222645.38805-3-john.stultz@linaro.org> <87r1zq4osr.fsf@kernel.org>
In-Reply-To: <87r1zq4osr.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=anuragku@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b95cd05b-d14d-47ff-af4c-08d7a01bf1dc
x-ms-traffictypediagnostic: BYAPR02MB5719:|BYAPR02MB5719:
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR02MB5719AB0BD833835C15B8EDD9A70F0@BYAPR02MB5719.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(199004)(189003)(5660300002)(64756008)(4326008)(186003)(76116006)(66946007)(66476007)(66556008)(66446008)(8936002)(81156014)(2906002)(33656002)(6506007)(81166006)(8676002)(71200400001)(7696005)(478600001)(26005)(7416002)(52536014)(316002)(86362001)(9686003)(54906003)(110136005)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB5719;H:BYAPR02MB5591.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D04twgkRwqilWhByGA273oQbIPMlXA8GLZo0WMY8PiHIBdWbqEP7UBPKayMmBGhNp1LUYv4yj6IjOx8jEknlf1g69e5lfoe86i5Y98u5DgFMJ86WJ9xNlZRvFqdngzfq99elulVNMAamx0Slo0bwZlWGeIP1M2Z5DM6hzeFeOf4VKImBehqcdNxuQ5d5A4nDJiKBeC7C5+IfGa8b+1T+Yloullj3AohJRIBXbfxRu1SEL0/nGnyPeBcrcGbC2n6dH7gC1X1uUR4UCwJHQuUPcM/1uJOWDxfZhs5WZz/dbVo19dIXlU9t66BEx2JAUaJ6Wqa0tcdSd/fzUp5bHh7nsEAXeFygjHo/wA8vab0lgrM+6/p0tKw0iwatTcguStFE5Vly1wt+yMd71ex1AuWtkAKDa60ei6tU2I3RlPRSRJJtjZJqD9diiNGpZzexJA47
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b95cd05b-d14d-47ff-af4c-08d7a01bf1dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 15:50:17.7338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iXBzndoZ+Ousrz9vv90w3IJG9AXNCz8Big+kKf6B5EYsKndpLv/Ojb5rA4MLVBLRR+w3UEWqM5cWPurDftUA2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5719
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Felipe,
>-----Original Message-----
>From: Felipe Balbi <balbif@gmail.com> On Behalf Of Felipe Balbi
>Sent: Thursday, January 23, 2020 12:56 PM
>To: John Stultz <john.stultz@linaro.org>; lkml <linux-kernel@vger.kernel.o=
rg>
>Cc: Anurag Kumar Vulisha <anuragku@xilinx.com>; Felipe Balbi
><felipe.balbi@linux.intel.com>; Yang Fei <fei.yang@intel.com>; Thinh Nguye=
n
><thinhn@synopsys.com>; Tejas Joglekar <tejas.joglekar@synopsys.com>;
>Andrzej Pietrasiewicz <andrzej.p@collabora.com>; Jack Pham
><jackp@codeaurora.org>; Todd Kjos <tkjos@google.com>; Greg KH
><gregkh@linuxfoundation.org>; Linux USB List <linux-usb@vger.kernel.org>;
>stable <stable@vger.kernel.org>; John Stultz <john.stultz@linaro.org>
>Subject: Re: [RFC][PATCH 2/2] usb: dwc3: gadget: Correct the logic for fin=
ding
>last SG entry
>
>
>Hi,
>
>John Stultz <john.stultz@linaro.org> writes:
>> From: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
>>
>> As a process of preparing TRBs usb_gadget_map_request_by_dev() is
>> called from dwc3_prepare_trbs() for mapping the request. This will
>> call dma_map_sg() if req->num_sgs are greater than 0. dma_map_sg()
>> will map the sg entries in sglist and return the number of mapped SGs.
>> As a part of mapping, some sg entries having contigous memory may be
>> merged together into a single sg (when IOMMU used). So, the number of
>> mapped sg entries may not be equal to the number of orginal sg entries
>> in the request (req->num_sgs).
>>
>> As a part of preparing the TRBs, dwc3_prepare_one_trb_sg() iterates
>> over the sg entries present in the sglist and calls sg_is_last() to
>> identify whether the sg entry is last and set IOC bit for the last sg
>> entry. The
>> sg_is_last() determines last sg if SG_END is set in sg->page_link.
>> When IOMMU used, dma_map_sg() merges 2 or more sgs into a single sg
>> and it doesn't retain the page_link properties. Because of this reason
>> the
>> sg_is_last() may not find SG_END and thus resulting in IOC bit never
>> getting set.
>>
>> For example:
>>
>> Consider a request having 8 sg entries with each entry having a length
>> of
>> 4096 bytes. Assume that sg1 & sg2, sg3 & sg4, sg5 & sg6, sg7 & sg8 are
>> having contigous memory regions.
>>
>> Before calling dma_map_sg():
>>             sg1-->sg2-->sg3-->sg4-->sg6-->sg7-->sg8
>> dma_length: 4K    4K    4K    4K    4K    4K    4K
>> SG_END:     False False False False False False True
>> num_sgs =3D 8
>> num_mapped_sgs =3D 0
>>
>> The dma_map_sg() merges sg1 & sg2 memory regions into sg1->dma_address.
>> Similarly sg3 & sg4 into sg2->dma_address, sg5 & sg6 into the
>> sg3->dma_address and sg6 & sg8 into sg4->dma_address. Here the memory
>> regions are merged but the page_link properties like SG_END are not
>> retained into the merged sgs.
>>
>> After calling dma_map_sg();
>>             sg1-->sg2-->sg3-->sg4-->sg6-->sg7-->sg8
>> dma_length: 8K    8K    8K    8K    0K    0K     0K
>> SG_END:     False False False False False False True
>> num_sgs =3D 8
>> num_mapped_sgs =3D 4
>>
>> After calling dma_map_sg(), sg1,sg2,sg3,sg4 are having dma_length of
>> 8096 bytes each and remaining sg4,sg5,sg6,sg7 are having 0 bytes of
>> dma_length.
>>
>> After dma_map_sg() is performed dma_perpare_trb_sg() iterates on all
>> sg entries and sets IOC bit only for the sg8 (since sg_is_last()
>> returns true only for sg8). But after calling dma_map_sg() the valid
>> data are present only till sg4 and the IOC bit should be set for sg4
>> TRB only (which is not happening in the present code)
>>
>> The above mentioned issue can be fixed by determining last sg based on
>> the
>> req->num_queued_sgs instead of sg_is_last(). If (req->num_queued_sgs +
>> req->1)
>> is equal to req->num_mapped_sgs, then this sg is the last sg. In the
>> above example, the dwc3 driver has already queued 3 sgs (upto sg3), so
>> the num_queued_sgs =3D 3. On preparing the next sg (i.e sg4), check for
>> last sg (num_queued_sgs + 1) =3D=3D num_mapped_sgs becomes true. So, the
>> driver sets IOC bit for sg4. This patch does the same.
>>
>> At a practical level, this patch resolves USB transfer stalls seen
>> with adb on dwc3 based db845c, pixel3 and other qcom hardware after
>> functionfs gadget added scatter-gather support around v4.20.
>>
>> Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
>> Cc: Yang Fei <fei.yang@intel.com>
>> Cc: Thinh Nguyen <thinhn@synopsys.com>
>> Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
>> Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
>> Cc: Jack Pham <jackp@codeaurora.org>
>> Cc: Todd Kjos <tkjos@google.com>
>> Cc: Greg KH <gregkh@linuxfoundation.org>
>> Cc: Linux USB List <linux-usb@vger.kernel.org>
>> Cc: stable <stable@vger.kernel.org>
>> Signed-off-by: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
>> [jstultz: Add note to end of commit message on specific issue this
>> resovles]
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>> ---
>>  drivers/usb/dwc3/gadget.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
>> index 1edce3bbb55c..30a80bc97cfe 100644
>> --- a/drivers/usb/dwc3/gadget.c
>> +++ b/drivers/usb/dwc3/gadget.c
>> @@ -1068,7 +1068,7 @@ static void dwc3_prepare_one_trb_sg(struct
>dwc3_ep *dep,
>>  		unsigned int rem =3D length % maxp;
>>  		unsigned chain =3D true;
>>
>> -		if (sg_is_last(s))
>> +		if ((req->num_queued_sgs + 1) =3D=3D req-
>>request.num_mapped_sgs)
>
>This is probably a bug on DMA API. If it combines pages from scatter-list,=
 then it
>should also move the last SG so sg_is_last() continues to work.
>
>I had asked author to discuss this with DMA API maintainers. Can you do th=
at?
>
I was stuck with other tasks, so couldn't discuss with DMA maintainers on t=
his.
I am sorry for that.=20

Hi John,
Thanks for bringing this patch back . Please let me know if I can help you =
with
anything on this. If you want, I am ready to start working on this.

Thanks,
Anurag Kumar Vulisha

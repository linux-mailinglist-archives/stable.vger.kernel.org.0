Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A38D25C5F0
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 01:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfGAXgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 19:36:39 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:60016 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726866AbfGAXgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 19:36:38 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8AF7EC01C6;
        Mon,  1 Jul 2019 23:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1562024197; bh=+WUkjo37UD0/qeRhfRnDAQj40ov+Z+tE7Yj66w6tdAg=;
        h=From:To:CC:Subject:Date:References:From;
        b=dtnmaqbTRR6kGPblOdVOfE7WQBaV5iM1mgBfyfG47y8oBp40wSXpzxYSxokANdUZz
         VvrPoTPJCLzXySd3nUsHN+Pnf98W1ZGbh+yUQ4iG4RHmHmkp/fKrDEka1PHVKpHayQ
         JB1hKYnjC0qP2za1L5jBTT/5SNtuhvFAuwUT1KBn6WI67MgsT24FldhiLUGBtXkyZ2
         WgCFCMvQg4/aqWBI+smhudbo7VvbKZUABBoOyDhxoL+3oSjV4lq4alejAOQSACap3r
         aLQUox9mocIoSyspcsEXgmSMtCjOGlEjvnttQ5YJ1d0H/7syRtEg1UYs6qGCT7Bcq/
         FR2SncIaFdXEw==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 0BB3FA009A;
        Mon,  1 Jul 2019 23:36:36 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 1 Jul 2019 16:36:36 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 1 Jul 2019 16:36:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=bIXG8nXKDZuF75ArRuXv+8uONpbu6/X9djOxjILGX+C58kCoVFDfxAG3bTFwp7w/Xz9hMYoNaFMG2U9iF/e1uND0AjwMRt+aDqU2/Kja/eqiYW0226ZgpVowY3aWRjUTjTfKBNJpP8pAcn1bUma2CiJ1hWvHSqy7CThgJcb2CUI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPL9tATMYVF7Pp05uCiCUL1y2YaVObvN0svEJUoBaYU=;
 b=wcdqlNtjL6kgpUCPjEliuWA3agIbMmrz9jFKR2gmfcrTGu5vObsPX2yXZ1db3O0tEbWIr0p3pf0AHp5G9M+Do9geI/RMFYH6SOcH3PUVHTJwO6U6W2Z6TYW5amF37NNspLjYgCtKil6zZYDZnFZtSApPcvaj+TCmgLrKbn8epwE=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPL9tATMYVF7Pp05uCiCUL1y2YaVObvN0svEJUoBaYU=;
 b=Jb0LZCraFlDuTrCApC9YxvqpnuGtMlquC4YtDk3QEj+xCg/qI+jRqVyB1uKbVfBfj+BU9f3gNa12GOhg8eFbmOPPoZQQvcNF1rywVrNhJPIIbufdHtyKOyvXWlKnt5WQJ2KYCBvGtI3cDRAP20GVwQWo/QFpLLuYPLfK+ylRQS8=
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com (10.172.78.22) by
 CY4PR1201MB0117.namprd12.prod.outlook.com (10.174.53.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 1 Jul 2019 23:36:34 +0000
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::f520:c8d1:43e6:5fc3]) by CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::f520:c8d1:43e6:5fc3%6]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 23:36:34 +0000
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     John Stultz <john.stultz@linaro.org>,
        Sasha Levin <sashal@kernel.org>
CC:     stable <stable@vger.kernel.org>, Fei Yang <fei.yang@intel.com>,
        "Sam Protsenko" <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        Jack Pham <jackp@codeaurora.org>,
        Linux USB List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4.19.y v2 0/9] Fix scheduling while atomic in
 dwc3_gadget_ep_dequeue
Thread-Topic: [PATCH 4.19.y v2 0/9] Fix scheduling while atomic in
 dwc3_gadget_ep_dequeue
Thread-Index: AQHVLd7CuQRa1B0Xck+F6olJkOIlJg==
Date:   Mon, 1 Jul 2019 23:36:34 +0000
Message-ID: <CY4PR1201MB003740D460297DCF1585B198AAF90@CY4PR1201MB0037.namprd12.prod.outlook.com>
References: <20190628182413.33225-1-john.stultz@linaro.org>
 <20190628225803.GK11506@sasha-vm>
 <CALAqxLX002_9jqCVpZ9esd9xj=ikC4soYDbCKH4etmUDYUXvrQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thinhn@synopsys.com; 
x-originating-ip: [198.182.56.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab39c015-742b-42e6-310f-08d6fe7cf44f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR1201MB0117;
x-ms-traffictypediagnostic: CY4PR1201MB0117:
x-microsoft-antispam-prvs: <CY4PR1201MB0117A7618301877199E1821EAAF90@CY4PR1201MB0117.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(39840400004)(136003)(396003)(199004)(189003)(25786009)(2906002)(6116002)(7696005)(486006)(74316002)(3846002)(45080400002)(73956011)(68736007)(102836004)(76176011)(66446008)(66946007)(66556008)(91956017)(110136005)(99286004)(76116006)(478600001)(66476007)(64756008)(53546011)(229853002)(316002)(6506007)(446003)(14454004)(5660300002)(86362001)(52536014)(476003)(305945005)(26005)(66066001)(54906003)(55016002)(9686003)(256004)(8936002)(81166006)(81156014)(6436002)(6246003)(71200400001)(14444005)(71190400001)(8676002)(53936002)(186003)(7736002)(33656002)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1201MB0117;H:CY4PR1201MB0037.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6vm2G9yS+ygE0XpI03ELbZ00C9e+PHbZRn/CG8W7LFesU9zbGqgl5EsZuH3kOHz1+w04VJwpolcxAOHbMtY0DaIoQPO62fsWvwt6yZn2DgGzWfWEpiVfDXzsFQzwE/9oLilCKDhg1118eX0aRdz86xX7ru+AeuFmHeZKPiXfs0fN7qusiutaEYv9yR2IR/CsZYsv7ymwWpTkGmj4yDK6NfcHyCj9o6fPnoyUJA8x5fl8X1thuPNNj4GOXWQO/Jj9A4heyNG2eS7LSpJzDp0XCHeC2Fw04DhpWBSeVVSIUcC78jHa7qp//8qcq68OjRGsQNT+ccVf6QczNUjYwBEZ8hRN++h1KEpYI93aubUECeytiMEASajnySyPHgrIfeYbRU235J4fbfksN848I3ZsyNhpIYfi2V83DSHM+pOXj8c=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ab39c015-742b-42e6-310f-08d6fe7cf44f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 23:36:34.5962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: thinhn@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0117
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,=0A=
=0A=
John Stultz wrote:=0A=
> On Fri, Jun 28, 2019 at 3:58 PM Sasha Levin <sashal@kernel.org> wrote:=0A=
>> On Fri, Jun 28, 2019 at 06:24:04PM +0000, John Stultz wrote:=0A=
>>> With recent changes in AOSP, adb is using asynchronous io, which=0A=
>>> causes the following crash usually on a reboot:=0A=
>>>=0A=
>>> [  184.278302] BUG: scheduling while atomic: ksoftirqd/0/9/0x00000104=
=0A=
>>> [  184.284617] Modules linked in: wl18xx wlcore snd_soc_hdmi_codec wlco=
re_sdio tcpci_rt1711h tcpci tcpm typec adv7511 cec dwc3 phy_hi3660_usb3 snd=
_soc_simple_card snd_soc_a=0A=
>>> [  184.316034] Preemption disabled at:=0A=
>>> [  184.316072] [<ffffff8008081de4>] __do_softirq+0x64/0x398=0A=
>>> [  184.324953] CPU: 0 PID: 9 Comm: ksoftirqd/0 Tainted: G S            =
    4.19.43-00669-g8e4970572c43-dirty #356=0A=
>>> [  184.334963] Hardware name: HiKey960 (DT)=0A=
>>> [  184.338892] Call trace:=0A=
>>> [  184.341352]  dump_backtrace+0x0/0x158=0A=
>>> [  184.345025]  show_stack+0x14/0x20=0A=
>>> [  184.348355]  dump_stack+0x80/0xa4=0A=
>>> [  184.351685]  __schedule_bug+0x6c/0xc0=0A=
>>> [  184.355363]  __schedule+0x64c/0x978=0A=
>>> [  184.358863]  schedule+0x2c/0x90=0A=
>>> [  184.362053]  dwc3_gadget_ep_dequeue+0x274/0x388 [dwc3]=0A=
>>> [  184.367210]  usb_ep_dequeue+0x24/0xf8=0A=
>>> [  184.370884]  ffs_aio_cancel+0x3c/0x80=0A=
>>> [  184.374561]  free_ioctx_users+0x40/0x148=0A=
>>> [  184.378500]  percpu_ref_switch_to_atomic_rcu+0x180/0x1c0=0A=
>>> [  184.383830]  rcu_process_callbacks+0x24c/0x5d8=0A=
>>> [  184.388283]  __do_softirq+0x13c/0x398=0A=
>>> [  184.391959]  run_ksoftirqd+0x3c/0x48=0A=
>>> [  184.395549]  smpboot_thread_fn+0x220/0x288=0A=
>>> [  184.399660]  kthread+0x12c/0x130=0A=
>>> [  184.402901]  ret_from_fork+0x10/0x1c=0A=
>>>=0A=
>>>=0A=
>>> This happens as usb_ep_dequeue can be called in interrupt=0A=
>>> context, and dwc3_gadget_ep_dequeue() then calls=0A=
>>> wait_event_lock_irq() which can sleep.=0A=
>>>=0A=
>>> Upstream kernels are not affected due to the change=0A=
>>> fec9095bdef4 ("dwc3: gadget: remove wait_end_transfer") which=0A=
>>> removes the wait_even_lock_irq code. Unfortunately that change=0A=
>>> has a number of dependencies, which I'm submitting here.=0A=
>>>=0A=
>>> Also, to match upstream, in this series I've reverted one=0A=
>>> change that was backported to -stable, to replace it with the=0A=
>>> cherry-picked upstream commit (as the dependencies are now=0A=
>>> there)=0A=
>>>=0A=
>>> This issue also affects 4.14,4.9 and I believe 4.4 kernels,=0A=
>>> however I don't know how to best backport this functionality=0A=
>>> that far back. Help from the maintainers would be very much=0A=
>>> appreciated!=0A=
>>>=0A=
>>>=0A=
>>> New in v2:=0A=
>>> * Reordered the patchset to put the revert patch first, which=0A=
>>>  avoids any bisection build issues. (Thanks to Jack Pham for=0A=
>>>  the suggestion!)=0A=
>>>=0A=
>>>=0A=
>>> Feedback and comments would be welcome!=0A=
>> I've queued it up for 4.19.=0A=
>>=0A=
>> Is it the case that for older kernels the dependency list is too long?=
=0A=
> Yea. It gets ugly and I'm not enough of an expert on the driver to=0A=
> feel comfortable knowing if I'm doing the right thing reworking this=0A=
> stack onto an even older tree.=0A=
>=0A=
> But I do see crashes on reboot w/ 4.14 and 4.9 (I and suspect 4.4 as=0A=
> well), so I'll need to figure out something eventually.=0A=
>=0A=
>=0A=
=0A=
If you're backporting this series, then you also need to apply these=0A=
fixes for this series:=0A=
=0A=
This fixes a race issue:=0A=
c5353b225df9 ("usb: dwc3: gadget: don't enable interrupt when disabling=0A=
endpoint")=0A=
=0A=
This fixes incorrect TRB skip:=0A=
c7152763f02e ("usb: dwc3: Reset num_trbs after skipping")=0A=
=0A=
BR,=0A=
Thinh=0A=

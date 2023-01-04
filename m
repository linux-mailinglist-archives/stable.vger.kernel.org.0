Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2952065CE35
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 09:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjADIYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 03:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbjADIYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 03:24:32 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534A01A04D;
        Wed,  4 Jan 2023 00:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1672820671; x=1704356671;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=umb5ybR34aEHxAgjSLi1VQUpK9Q4dJw2Md+i3WyD1wU=;
  b=J1/u43Ivh5g5VxAQZUG8IodxskcFvSt5GKNGmT5YeA5t25VpSHXv13/2
   ZJRf0NYEtW3QWvGR+2U85Ia82pdcUB8kAIdAfTIsX6RxjtCGtIIn1R9Cz
   kzkkWkq7UeB7f/eXXkLRSTcTus78aoWxLrTZzziaK3CSmU7w6XzVmRKyn
   a+zYXO0Kk8yVm6QeCcAmBPptJvzBgMMGnV3Zvbw0Yz/wE+gY3LXzgYlG8
   b2kDCTC8lXpBZzndb59xYJ1XOykZL/5HiYuC+jWhkM4IB/gE/UXsq6V5r
   ziyDZPhPH7FjudhL/sTtHoXNOTScMiEyaJyDbBX2vH8A96j5hdiSs9N3B
   g==;
X-IronPort-AV: E=Sophos;i="5.96,299,1665417600"; 
   d="scan'208";a="225048378"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2023 16:24:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDFVnQj38fKO+bEWy5MaLz6VYSgsN9fhpOSTbvEquE1BeM9OoGFcWWa2hiJL2mtUV5uBFQZejwaYOOHfmwJMcNJ3MDjkIwuSdUHFJ8NumifzyobUCpmPnBdnBpF4MQXj8T1JMWyBmwf8My6SvQKacUwkG9BWkitySeia5fY3rYYE2Sbvk2x+RMsanlTk0wSpYAjFwqU1MQZjUcPNOwnKSI5rO8pNokjLWuC1SGEltQD/vVTK6ualMcghZ3GB1gkRKJUDL27JuTTZZ8CcsRGZCwk8gzHZtBU8yrmFOPCxju5eYXVCooZ1C+16GTkdF93s9HFyySr6Nno3BlfqZ9tL7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=umb5ybR34aEHxAgjSLi1VQUpK9Q4dJw2Md+i3WyD1wU=;
 b=KxH37AfwcgslIzzjFx+kjNmzMSb0Pb/R1dBNUd44GiVtxcVtwJ20zYzWAggJrwWKVLwFAXU4WgScN3w5stcbqfqNKaKOk+5E0oFUGkYTj/ewCJosZxgGHTRTA6TErsgE7F9TnMacNIjK0OgjTlu+TT3ASUiiUsJU5Hq8MsEFvmntullizcZv8SUiQ5N9PaPQZwEyqdw2+IsMvdm87xHngrYpItLp6k5C0NDnJlIXwiwHT4NQnlIOv1RhfwD0corkxu7R5lAX5mT7kx6GX1XN+4ZG+I6t7Fqebts8jPcxzIxEFRuMMI/WcNhWS69CLw6II8lK70Uy8bR0xlR78PD+rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umb5ybR34aEHxAgjSLi1VQUpK9Q4dJw2Md+i3WyD1wU=;
 b=yRq+6cbAljU55trjLBAZlqSXQ43EvI8+74NhygfG+sURtpX/hD+yC5qSitH4dXoUemzx16P/iV6ZE9lfdOdrFP/pVwBA9GVVgMyaRRmU0Ti3pVc0sOtr8nI5EeJ0GQdNHaLoqPUBSMQXcl4byf7vsXWndV27V2IXJ7KPw7b34+s=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN7PR04MB3937.namprd04.prod.outlook.com (2603:10b6:406:c2::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Wed, 4 Jan 2023 08:24:25 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::1afa:ab74:ef51:1e72]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::1afa:ab74:ef51:1e72%4]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 08:24:25 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Can Guo <quic_cang@quicinc.com>
Subject: RE: [PATCH] scsi: ufs: core: fix devfreq deadlocks
Thread-Topic: [PATCH] scsi: ufs: core: fix devfreq deadlocks
Thread-Index: AQHZH7ytIv0nmKZpNUaZ7D6pWDZRBa6N6x0g
Date:   Wed, 4 Jan 2023 08:24:24 +0000
Message-ID: <DM6PR04MB657555DBC49DF54716A98B6DFCF59@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20221222102121.18682-1-johan+linaro@kernel.org>
 <85e91255-1e6f-f428-5376-08416d2107a2@acm.org>
In-Reply-To: <85e91255-1e6f-f428-5376-08416d2107a2@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BN7PR04MB3937:EE_
x-ms-office365-filtering-correlation-id: 89ad5e5e-bef4-4ba6-d0d7-08daee2d16c1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vAYHR/DIJyFuEUjW1CTu8vtyOiUGu8+OAIgUxG+YS4GmSO++W47L7pKL2mEgd7QROL827/x6peMTlFMLwgEQnM981ZRUfUf/pGvmff/LeiALi1PkJEEh/r9Ks8UDrx3LRlzZqI6R/pQIEeNeSpkUjkBVZx7H0oIpxi8Guqw38WecVyT+oAQQCRYbM2neCERZIfjvPLMEhUFTMZM3CD4+oj65UCRDWoWhQi7zZsoVnfgbskEmxzUl0A1V3hKaYDi8jZWe+ku4Rgnrae7nno/6nG/vm6anIxrf3yN52dFis23/Kdel9dW6CFojEsZpffWrEb5Bfuy0IvPexPwiiSv71EwEH0tgeipZsGIgXjSCcxSiDVJk90AmDhk19+Hlnc3Nw017mRmfVcH6M2zAE2XMbBU8rVbOZkb6WWldUQwq83F0/4TG8jVo2boqyq7b0kISJw3/EJbqro/droKbxmJsqiN102GlolLS0pUNsqul+ZST8t//tChpAR9Yk4BQx3aU5NxF7gQg7Q7VJOgvqu89t4jkNMpJvJjxUpxXijXa3OlTPA5EKRWxrdRoc7KWwZsyUCvK67zUiYj85XoTGt5pdyEdrF/6qS8rV+1YeZ2HOX1qf+zOyq9V4KEWtxouE5s4kzyinwiRJS2BWrkrSa3jHYGBYW8FIRfN7yebeSkm6MT+4gX7e1OeihfESUR+24FRxEzvhfgJlz6+jheuTQl7CQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199015)(86362001)(8676002)(7696005)(66556008)(64756008)(6506007)(4326008)(76116006)(66946007)(66476007)(26005)(66446008)(9686003)(186003)(83380400001)(478600001)(55016003)(54906003)(316002)(71200400001)(110136005)(33656002)(38070700005)(38100700002)(122000001)(2906002)(53546011)(82960400001)(4744005)(8936002)(52536014)(41300700001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azlMMjZLYlJUVEhSZXovSjJ6dXJrem9qYkU1NTlWV0dhRHdlNFJTVlEzRHo2?=
 =?utf-8?B?NG5OV2ZxbVJnSkQ2TEZ4ZHpMZlo4MjRhMXFMNXQvTW0rNklYalB6c0JpT1hl?=
 =?utf-8?B?OG5RdVo5UTkyUFRHdnEzZmhEMHZIaXRjZE1jbmlwSjhVdzZpM0tKaWtreHkx?=
 =?utf-8?B?RUZSYS9rbmNva1huVWsxMDFwV1ZKU1h5TjN1TlY3SkdOdEcrOUt3L2xzVXRm?=
 =?utf-8?B?eU5qcEswWEN4KzV0cld4T1FBZlJJUDBqZ3Y1U2dMOXVOY29QR3orWEZLQ1pm?=
 =?utf-8?B?bHdHTDlMTWJFaStxVmIrUGYySkRKc2RnSU9nM2Qya3VhSHRua1JjeHlRUlpy?=
 =?utf-8?B?RXF2bEplNGIxKzJrYlhwVklXZkpxMSt2TEVyTnI5eHp0M251QXhWWW1vQ1U0?=
 =?utf-8?B?d0pXdExSbk1FY2xSc1FneWhJRDRWOS9obmgwalZMeWV6Zk1Tam5YMFRzUVF3?=
 =?utf-8?B?Zy96U2VjbjhCK0IzYTNNSlZOQjcxSTZmdGh6Sm8yZ1BJRUVDWEpKdDdSWkVF?=
 =?utf-8?B?ZGNGcTJiTStleWd1TFVCMzVwQnE5UjFrNWZEME1RL0tVYlBZQWE4MlRPOWht?=
 =?utf-8?B?WGxOM3lMTVVMM2NaQmVWTG5NVE1VMm5WdVNsVmdBWm9YcFJNNGNqNVZyL21s?=
 =?utf-8?B?RVVxbmZWb0hwMEEvckZET3JLYU1YbExRRUg5ZE1seTd1MVBwR1BIejA4SnYv?=
 =?utf-8?B?LzVrSCtVUDlKc0U3VGtGMXk3L1F3eHVCN0RKT2NFd2syMWF6Z2tlY0ZEQnVN?=
 =?utf-8?B?WmoxSU1mTk1mcG4yYzUvNjA1bHVVQVdvaUY2eUVHVFpFRkhWNEJUVy95TmVj?=
 =?utf-8?B?TEl0YVdFc1l6b2Zmb3UwOGRIRnpoVWhZRUFHVW5lbmVvdGdwWFEra3ZXWkxE?=
 =?utf-8?B?Nk8wMXkvdWwydGFMTEc4Z0pUeVNQNDMyN2hHVW4xaTIyTVhCQUd5U0xGcXJY?=
 =?utf-8?B?aUxLTmd6ajYxSkJqcllmU3FHblR5a25Cais4SFNJVVlWTXpiVUFRSGM0NmxQ?=
 =?utf-8?B?dHgrQ0NSSUgzM0RFdnlIK01Nako2clZZby82N2s0eGRkazlOaDdNKzRXVlFz?=
 =?utf-8?B?T0xjdzh5OTlhMmZvU0tPMWszekNaS01vajBvT2FBM242V29kRjhmdGNEei85?=
 =?utf-8?B?WEVhb2lqdUxJa2YvbzVNRnh1MWs2UmpBWGozS0paanVjMThpZDhWRk1seEYx?=
 =?utf-8?B?UWZVYzBEanJFMFo4TU8xdDJ2aG44T0NlN20xbzVkMEdHOFlpRHpkLzUySVhN?=
 =?utf-8?B?YU1QdWlzQTl2NmFxZVV0WCtMc1pKeWFETTRLZ2dmV1pEWEpzYXR2Z2pmcHkz?=
 =?utf-8?B?eWNHWFlGK044VDZhTmc3c3RBazFPVkw0cUxPY2Z3c09GTFNKc3o2TkwrVmVN?=
 =?utf-8?B?OHBSRCt3R2NJYTZvUlhSbGFISG8xWmpaZHZid1l4V2JjTVVUWFdLQVl2NXRR?=
 =?utf-8?B?THlzNnZGS1BNTHZNK0lXbDBUay9BSi80S1JlUWpFY2JBSzBtcXR0eTdWK3da?=
 =?utf-8?B?MDNBZm9IRXBlY0FmNk9mSm5GK1lBdTQvVFRMRE1kbGpaSzNaSkp1ZCtjckp5?=
 =?utf-8?B?dTNaZkV6TlZiRVNocTYyZVJGVW1jR3lBejNaNVdlVVZBY1FROFRveHpuc1ZW?=
 =?utf-8?B?U0l1M1lUWkpKRyttV1k3bDJQQnFacllUV3N1VUdkMDdSS2lvNFdqR3FlbHhv?=
 =?utf-8?B?U25kU0xQVUUzdmxZUkxkSENmQjBOcXdNZG5NT1l0ZWc4aW13ZDk4Uk1aRVg2?=
 =?utf-8?B?cnZBZkZyazBBbkRLWnFvK1RwS1dKYlliS1pTQlJIMytOMUhZalczeWszSjBm?=
 =?utf-8?B?aVFBWHZNclFTTW5RTWVEUlhyQXA3blZWR1VnT1BwY0U3Q1lIMVI5VHFvQ0pB?=
 =?utf-8?B?R2dJd2VJMWNlMUM5cEh2Z2gxSGZMV0lMbENXMmhFTUV4cnIwM3JTOE1CU3FS?=
 =?utf-8?B?Q01SRmY5RjJXUFZvaTBJT20rQlNiaUQyaThJeS83dDBCM3poa0N5VXc5eFE1?=
 =?utf-8?B?R1lEWjRqMVZsTjRBYkhaRTdIN1VETk1SdXhTQ3gxNnN4ZWMwbm1DcTBGdEIz?=
 =?utf-8?B?bHg3S3FiZEVqTkJ6MUd5LzEzZS9RNTBvSy95eWlDblBiMHlHbTlZZzJuRkZa?=
 =?utf-8?Q?xHkGBUQ7UXMDniFdDmxG+oSsy?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VVBnWDJIOG9VZ3ZoU055WlZhN3R5eEZURXBhRlBOU1N0ZkVZSjhBdEJUMG1z?=
 =?utf-8?B?ZTM0WmwvbGZic2szeW8vWi9CcExTbE5oVWptdlU1bDZjNlkrVE56S0ZqVkVv?=
 =?utf-8?B?QjN5SlFmZlU3a3BoUGMzd2ZSRTV4YjdqV1FOT2lmTEtWaFlqQzEzbnFOMGhx?=
 =?utf-8?B?VTRpNks1b3lMNWtQNVVmRWVRYzZOZ3hTL2hubnVZZ0JaRUpoZEdmZjY5eE4r?=
 =?utf-8?B?OFptZ1dpZGprYTVUUS9FRmY5TzY1Z3FiaG4xWVEzTjlJWmwzRVRJNGh4S1BO?=
 =?utf-8?B?dkZLeGNZMGJYVE1NQXV4UW14VktGK2xKZVJlT09qbXB2WmtXd2lkTVEwMlRv?=
 =?utf-8?B?TnNtdVpMbk14SjR3WWxjcWxjMDQraVRiNXlDUTUrY2JnaHVqYlhRWXppOEE2?=
 =?utf-8?B?MXBpUmZOT2V3SFU2TmkrN3hhRVFLdy9BU1RidnBDZlo5THM5L05PU3drdnRD?=
 =?utf-8?B?NWlZV3VoSkF3NVhQcUk0NGJTcTNBTTJYcFN3amkydWpFM0tUQWdXaUdwQkQ5?=
 =?utf-8?B?Rm41REhkYXRMakhlckZPUzZUSytCSDg3ZC8raVlZcW43WVhBUTYxc1NHMmFI?=
 =?utf-8?B?cEZtc0R6Zk51c1hDL1EyajNORFB1TXpCektWVG5wTGxWeFRPNnU5MGVOMktR?=
 =?utf-8?B?WkM0WXlST09rUHp4QXBqQnJLOEVhNmtaNkxYNjRVZUpjWkVGSklqRHkwZ3FM?=
 =?utf-8?B?bjAvSHJlZ0pER3d3dFI1dHlSVWhRUVcwRGtDL1ZVZGYxQm1IOElaZzhsdlNq?=
 =?utf-8?B?MGw2VGFGUkxuZjVJN3JxMUt0MUZaZXYyVHp2ajNlcW5XdzY0V0dFWnZEZVor?=
 =?utf-8?B?RDlNTkFhU2pNSHJjVXczelc3RXlscFhMTHpDejA3bWxMYXhzaXVmT1lCUmxm?=
 =?utf-8?B?czRDaE9NMFNDaGxURC9XL1lrakZsNmdmUkpLeUJ3QmhaVkNpWGUrZDhnaVpT?=
 =?utf-8?B?OHRSQlhzY3V6M2ZXWThaQlYvK0ZsWmJSU3JUS2c0MW95RUR1a0ZIei9UZENj?=
 =?utf-8?B?eWpXVEFqaDB0Q2l0a0s4elhtSnlCMnhkV2NVZ2I1SGpJTGUrVG1WN3pkcnVi?=
 =?utf-8?B?TFlwekNJR0hHckdGUDBZMytZcklSbEZJOVpNT0I1SnJsRHY0K01zR2ZHWXR6?=
 =?utf-8?B?dDkzTVVKUjVmZnhHL2FMbVVMQlZxMzVkN3ZPOEdJb1pCYnhJRWltcjdUZE5H?=
 =?utf-8?B?R0M2dFFweEt3cDEzbDQ3SjY2eHcrVnBXR2ZDZzFpczdyVFlMeVNycE4raW5K?=
 =?utf-8?B?SUU5YWZKaE00eEx1b2ZaQWhSb1Q0RlFFMzZyTzNhbER4TUo0Z2htcndTMUZ1?=
 =?utf-8?B?Rm9FN0xyZ1E4K3Rzdzc0d0pnQ085YS9OMkE4MHZLbGRNTFQxOXI5K0pPa3lU?=
 =?utf-8?Q?ZxnPrWD80F/gwzYqWzlRUMh1s/gW1Q0o=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ad5e5e-bef4-4ba6-d0d7-08daee2d16c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2023 08:24:24.8461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CdkwWUyps2YpysVwfyJsv1u9K2zb4rYKR9UlV7IuNCqoffMEuJBIDC8nB6Hy3eHXOfem2e01Hv1Un38ikLQKjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB3937
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

IA0KPiBPbiAxMi8yMi8yMiAwMjoyMSwgSm9oYW4gSG92b2xkIHdyb3RlOg0KPiA+ICsgICAgIC8q
IEVuYWJsZSBXcml0ZSBCb29zdGVyIGlmIHdlIGhhdmUgc2NhbGVkIHVwIGVsc2UgZGlzYWJsZSBp
dCAqLw0KPiA+ICsgICAgIGlmICh1ZnNoY2RfZW5hYmxlX3diX2lmX3NjYWxpbmdfdXAoaGJhKSkN
Cj4gPiArICAgICAgICAgICAgIHVmc2hjZF93Yl90b2dnbGUoaGJhLCBzY2FsZV91cCk7DQo+IA0K
PiBIaSBBc3V0b3NoLA0KPiANCj4gVGhpcyBwYXRjaCBpcyB0aGUgc2Vjb25kIGNvbXBsYWludCBh
Ym91dCB0aGUgbWVjaGFuaXNtIHRoYXQgdG9nZ2xlcyB0aGUNCj4gV3JpdGVCb29zdGVyIGR1cmlu
ZyBjbG9jayBzY2FsaW5nLiBDYW4gdGhpcyBtZWNoYW5pc20gYmUgcmVtb3ZlZCBlbnRpcmVseT8N
CmNvbW1pdCA4N2JkMDUwMTZhNjQgdGhhdCBpbnRyb2R1Y2VkIFVGU0hDRF9DQVBfV0JfV0lUSF9D
TEtfU0NBTElORyBlbmFibGVzDQp0aGUgcGxhdGZvcm0gdmVuZG9ycyBhbmQgT0VNcyB0byBtYWlu
dGFpbiB3YiB0b2dnbGluZyAtIHNob3VsZCB0aGV5IGNob29zZSBzby4NCldoeSByZW1vdmUgaXQg
aW4gaXRzIGVudGlyZXR5Pw0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IEkgdGhpbmsgdGhpcyBj
b21taXQgaW50cm9kdWNlZCB0aGF0IG1lY2hhbmlzbTogM2QxN2I5YjVhYjExICgic2NzaTogdWZz
Og0KPiBBZGQgd3JpdGUgYm9vc3RlciBmZWF0dXJlIHN1cHBvcnQiOyB2NS44KS4NCj4gDQo+IFRo
YW5rcywNCj4gDQo+IEJhcnQuDQoNCg==

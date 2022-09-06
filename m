Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470995AE4F7
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 12:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238575AbiIFKCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 06:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbiIFKBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 06:01:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0851771983;
        Tue,  6 Sep 2022 03:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662458513; x=1693994513;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DuR2d/WFZMvJ87paG/H5w0x/dfJZdYwHoCwKTjD+6F4=;
  b=g4s8Po9RXYlO3h9kvRmKp4zMi6M2Y8xSPypc0OyA7f73Tf1vk7UmDfh7
   nZlAvQ7fWWZnJ1lBf8a7fjidS3eEBGomeiYlJ65RzLnA6+b5YezDJXUqK
   hrDAiYK1Q6hcrs9mmUJLi4/xuN/+Bnyb2WBha/pHx4ZY9uqu85dmRBN8w
   jrmORMY3TRk2f+FhK78cOr20nX+FJIOWhGxYV8PIyAhvlHBFNhPMUCdIP
   UI9sN8iGIZFKEoyVl+eKtGZ7njODa9KGm5Rd/6u8y3e54sJYBvZZq5+eq
   mY2LE1rPU+m+TJ7w+zvl8hHHRpnhqAF3qCyY6wdvh+YSRI2ZCkrctD/Sf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10461"; a="276948012"
X-IronPort-AV: E=Sophos;i="5.93,293,1654585200"; 
   d="scan'208";a="276948012"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 03:01:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,293,1654585200"; 
   d="scan'208";a="675625581"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 06 Sep 2022 03:01:52 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Sep 2022 03:01:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 6 Sep 2022 03:01:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 6 Sep 2022 03:01:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nV/YQCD8hi9xzikYN+isdI6eH7rXgZRsAc9CM3y4Pn5yuAXfiDscHmGoxripknoUZ1RBE1AsDt5cIXZ6NXkgXPGLGNGoVFpdey+L7iTNqJWxd1q6smLlXhFt67Clhb4mCtRicp8e3q4jCvyFdviYGmeyFb3GX9Jb5ycpJfkhiGvHRdS92e1zXBXHJqKg5bd+odL5tA/eAv+C20xnP2bdU2SCRmkljQ91s0XDd1zngivnaiU99t7iII2F6HfntAxQyl5XWyT/GbN9LdLv2MDRWLwLLjyi/3aHsfz9QiYct7wPeVg9eOS7iMThKyl5zqUXiWQoJMwURsyVeT1qPZwYTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DuR2d/WFZMvJ87paG/H5w0x/dfJZdYwHoCwKTjD+6F4=;
 b=WHWmLhW4YNJb7xGRjF/UdsaP60ABQLr/jXe+ZXQDGw0+cr52J4ififhu8YGiiPYPgRbhW9pbdxDf0EqvM4x2TMPRR1g/Pb/cs5mjyWWcoe0VSWC8bWSNzw5xejuk3Vp5WqihTkqJ8pgm8w+i67bnrwTbvzq0b9GFyprBQx+clanUGZQO1NHz40SzR9COvx+Kvu5ylKjkJlDT5H/9BquUeRNHalcfr+rc5QOhL+BepDCWP3ZuSiTVgxkfCMuZ2rZ8eY/kfhhEP4M4j33A9RJUg0mm9tacxf4UqccDa/ygAAH/mtWb5SG4VkMBpscvzpKXrjUexAD9KSU/DlTfvCt31Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4496.namprd11.prod.outlook.com (2603:10b6:208:18e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Tue, 6 Sep
 2022 10:01:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708%9]) with mapi id 15.20.5588.015; Tue, 6 Sep 2022
 10:01:50 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>
CC:     "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] x86/sgx: Do not fail on incomplete sanitization on
 premature stop of ksgxd
Thread-Topic: [PATCH v3 1/2] x86/sgx: Do not fail on incomplete sanitization
 on premature stop of ksgxd
Thread-Index: AQHYwYP9ngFb8RuWrU61zZkTOIOLX63SLFSA
Date:   Tue, 6 Sep 2022 10:01:50 +0000
Message-ID: <eb23aa52c7ef9a6665bc966972947a085a1d1af6.camel@intel.com>
References: <20220906000221.34286-1-jarkko@kernel.org>
         <20220906000221.34286-2-jarkko@kernel.org>
In-Reply-To: <20220906000221.34286-2-jarkko@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69a5338d-df8f-4790-762c-08da8feed146
x-ms-traffictypediagnostic: MN2PR11MB4496:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2jRBY2SCb3vKLwZTTSCCoQtWsdANV0g173/tNOfUkn4ZHWBhwpiyy1G/TRuWyNQPYYL+Nmew1wdApqdgu1hNJcEadsfDGVF68e8SPrNncD0PuZdkloJXFbGBVwOxFSBZBQjsXJNnh8bjs8zQF7kU/xsUJ09clqb5mCfC7LULPZyvUG7s5Vua7Z0LIm2RGtJQcWK65IzEcZbKDvkYDZN5aWmJcQlXu+eNcAixDNb60GHGDSOrKyZ+NqmyfakinXV2f2Y+w4CxNP+gdQGRo/NJWyZQ2b21F2P7yVQC/ruf4gHym36M8nvbWEPHpo1/9xw/26SEkeUqgMxpLut0jeiDl+JmD7qo53bKiHwq640BzN5Zm2sskvSipXaCEUpuZDUBYgB5/pydlMQb6tmzCBLOh5ZnHMYMChsD2NCe2wzmxLkie63icnum5lGp0YSYi8haqj7acNYp4konE4ZLdlPAp3QgSKUhVXEXKACWT8TjmBNNBZfbxA5d78hqK4wojGy8dvViXjL2MW4QdiTbRGq3HJvi9B5RJ0TT7Qp8E4PiwmIl7F05JkpS8B19l6Mt8b91kFbs7GT22/S7WPmFWmvTK3MAQzTGovaQcHNwfUAbsiXO2O8SbFYBg/t/dQqmJf6XhvwsSYx6UdROk4yQTYAWirj9KzHVIf3MVx4Jp+GD+CliB4QhWGKXBVvaCdh1E6W7TCdzlE0G9kfAy7j1VqmufW7BztbTJg3JWkB7GxzZK+IzW3xlNtX27IF7hR/4qbCD87iXtKlRTwXLJbajjOyaJ7kTd4LzsDwrYwHGYt47a9A9vevkBAhiKvHjBm25uDFl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(136003)(376002)(366004)(39860400002)(82960400001)(36756003)(26005)(2906002)(6506007)(6512007)(66476007)(4326008)(66556008)(8676002)(76116006)(66446008)(64756008)(66946007)(7416002)(8936002)(86362001)(5660300002)(316002)(71200400001)(110136005)(966005)(478600001)(41300700001)(38070700005)(91956017)(6486002)(38100700002)(83380400001)(122000001)(54906003)(186003)(2616005)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1ByaW84cVFScXBRWHNwOTdkRHJQNmIvMHIvTVBoc1BhZmNlWnBNODM5M00z?=
 =?utf-8?B?WFdEeW05eUhvQ0x4VWZUUCtzSGQ5K0xlSlo4VFRyS1h4RXphSWdHTWtYcWhE?=
 =?utf-8?B?UkNtbS83YXUwMlVXY2wrQWcvZ3p6Qy9ML2ozV0g3LzlTYm9QNU5ZTlZzdk9W?=
 =?utf-8?B?cjJtcm9yYlBkTGkxVS9DZVdXMWlKY0ZRMys5UU1zbkpRZTNyMVV3NzBBRThT?=
 =?utf-8?B?MHdhZ05wclJ3a0Iyakh4Z1pjaUhqUGVsK1R2WkliN05jWGZrMEJKQUkvNEVv?=
 =?utf-8?B?ZStaZC9raUpUVFlhSDBoMTM4ZlVWbzBVNkxZMlo2aHV2dzNiT2pHSWcyalU2?=
 =?utf-8?B?SXJVbWcvWUorWFdDOEZpdzFhSDJGQlIwM0xrSFNLMmp2ek45ZDNsbGplS1k0?=
 =?utf-8?B?Z1RNMDZoRGdwTzVJZ0VpbG1Jdm1OU2ZRZEJmZVNhdDV2YldkYzMzbCtzMmlT?=
 =?utf-8?B?UFVIL0RLbkJxWHk2b2l0TGNQdGpSaStwZVVqczBBZSswQ3NjQWhHUFkyelhB?=
 =?utf-8?B?YWdzYTdycy9uRDlmUEo5Qm8wdTNMWnpVamhNQ2dYVWJFM0pNaGo0U1NTYXZr?=
 =?utf-8?B?MzY3S2l2UlI1bTk3ZUUvVWE1QWRqaTZ6Yk12WXBhQ1hSNmJsVElHRWlzUStp?=
 =?utf-8?B?Z3JHUmJiVlk0V3V2b0hDRXc5ZW5VYmc2bFAwNDU2eUhaV3h4TmtMdlBLSTB6?=
 =?utf-8?B?eXhLWEVOd0o2cjNyYm9penBJTlYyQTJzeXE3V2xlYzQvK1VQU0VIWCt6TSs5?=
 =?utf-8?B?d2x4QXA5OElJWElCRkF2ZGtoSDR4NWNnVmtkKzJJbXE5L3pyUEJhK2FROVZJ?=
 =?utf-8?B?MWhBdkVENVQ0RjJ4bU9EYTJOVldpdnpjT0tiMWV0Y25SSkgwbkNrcWNMclUx?=
 =?utf-8?B?YU42akJtK1UrU2dNYXZZOFNaR04wSXFaalh1cWQ0dVVoRFNiRExwUXhkOUF0?=
 =?utf-8?B?dmFVTXc5VEpEWjBHOHlWZ3hsdWdMUjg2MUg4THRtZUx6N2YyTDA1T3IyZC9W?=
 =?utf-8?B?YnZKR0RWcTVmbkxHbEZQL2tMQjFtN3BOTi9FNVFKYk4rUVFadzBCVHVFblFa?=
 =?utf-8?B?U2d4OU1uYlg2cWtTQkoxVUNYNkNDZVl6anAwSkQxSlhxT0VidXBpQkhNMWdq?=
 =?utf-8?B?c29VZCtya0VESDlJZ2hGTVYxb21hd2lQcHdsTnY1dHo5aVpsRDFUUTArSFRz?=
 =?utf-8?B?RTRnNlFzSWlLT3hyb0kyYlRiUVUyOU85a29SYi9zWjV2UVZOVnJ0ZGdnMWhU?=
 =?utf-8?B?aEJ0clZCV1FRQkIzQUNzK1dtZzBGWFJqa295VXJCM1ZzcnNlRm1VY0NwOHQr?=
 =?utf-8?B?dk10U3kwQU5PbG8vUFlCT0FTcW5YRWh5Njg2Z1ZLREgxTXVhSDVYUmJaT3Ji?=
 =?utf-8?B?ejRxLzY2VjAxT0dqWDJrUW9JQ2dGanhJRFh1anpyemMvQUhvdUtzQTZKV0pS?=
 =?utf-8?B?QkQzc2kweFo0OFpYV1pxTU1HS1h5RmpLK0NqU0R1ZVBCaHEyWVhicWNYcHUv?=
 =?utf-8?B?U1ZQRHl4aEZDcUpmSUYyZVNzcmN4Y0RES29HQlhtV2xsMDFXbHExTHVEd3B6?=
 =?utf-8?B?Q1cxK2NPNklld0d1b1RJWTNJTnlMUUJqYm5maEx0OWJncGc5Qm5naDZBT2Iz?=
 =?utf-8?B?NnBMZ1FhL28xR1g3ZW5uZFJYenV1NTUwUkd2cFM5TzRhVUVpTlZuSTNqQmhB?=
 =?utf-8?B?MWN1U2RGVC9NZEFDeUNRZzJuWUlmcitqQllYblhvZEFNOEh3dWNhdEhYN1lQ?=
 =?utf-8?B?MEhzOG1HSUoxNmNzdnB6eE9YSGJjbXgwSGQwR3cza2lya3o3amVkYndPRkhE?=
 =?utf-8?B?aU1UTElnUG9sQ1dzdHNFVGw4VjZMRzNCN25WNk9jMGpja053Z3JRdW4rajlr?=
 =?utf-8?B?WXY1TEw0cFhnUlQyWnVYSXVBOUZlV1JsY1VUUU9WV0RvcG8zcy9YanFFbVB5?=
 =?utf-8?B?cmZrOUtienB5cENYeEtCVlY5UW95VUpDRStLTWJKem95V1BvL044VldYaFZQ?=
 =?utf-8?B?dnQ0NlVwVFNnak8zZnFqR2ZIdlNlbktvdlBzcnY5Q3p2cDFCbGJaWlgxUThh?=
 =?utf-8?B?YUs4N25MVnVCQXlWbDltVjF3bVlYN3J6Q0VJam5qNGRHNi9pR2g3VFRCTEZW?=
 =?utf-8?B?Y0RLVkpBd3FEdnFKTkdQR0tPSGk3KzdmM0RCSEU4aUdXZ2NxWXF4NTRVSG5Y?=
 =?utf-8?B?bnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <591AA1FFC667624890F6DC872918AAF3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69a5338d-df8f-4790-762c-08da8feed146
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 10:01:50.1922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wQ+uKiPMd5Lr30HWYfSfiTj5FbCPCTjXHh1lHdrhs+jc7U6uP+ud8Ayb3QERMI95MbqDZKZhRGmlV4wPBViiMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4496
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIyLTA5LTA2IGF0IDAzOjAyICswMzAwLCBKYXJra28gU2Fra2luZW4gd3JvdGU6
DQo+IFVuc2FuaXRpemVkIHBhZ2VzIHRyaWdnZXIgV0FSTl9PTigpIHVuY29uZGl0aW9uYWxseSwg
d2hpY2ggY2FuIHBhbmljIHRoZQ0KPiB3aG9sZSBjb21wdXRlciwgaWYgL3Byb2Mvc3lzL2tlcm5l
bC9wYW5pY19vbl93YXJuIGlzIHNldC4NCj4gDQo+IEluIHNneF9pbml0KCksIGlmIG1pc2NfcmVn
aXN0ZXIoKSBmYWlscyBvciBtaXNjX3JlZ2lzdGVyKCkgc3VjY2VlZHMgYnV0DQo+IG5laXRoZXIg
c2d4X2Rydl9pbml0KCkgbm9yIHNneF92ZXBjX2luaXQoKSBzdWNjZWVkcywgdGhlbiBrc2d4ZCB3
aWxsIGJlDQo+IHByZW1hdHVyZWx5IHN0b3BwZWQuIFRoaXMgbWF5IGxlYXZlIHVuc2FuaXRpemVk
IHBhZ2VzLCB3aGljaCB3aWxsIHJlc3VsdCBhDQo+IGZhbHNlIHdhcm5pbmcuDQo+IA0KPiBSZWZp
bmUgX19zZ3hfc2FuaXRpemVfcGFnZXMoKSB0byByZXR1cm46DQo+IA0KPiAxLiBaZXJvIHdoZW4g
dGhlIHNhbml0aXphdGlvbiBwcm9jZXNzIGlzIGNvbXBsZXRlIG9yIGtzZ3hkIGhhcyBiZWVuDQo+
IMKgwqAgcmVxdWVzdGVkIHRvIHN0b3AuDQo+IDIuIFRoZSBudW1iZXIgb2YgdW5zYW5pdGl6ZWQg
cGFnZXMgb3RoZXJ3aXNlLg0KPiANCj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGlu
dXgtc2d4LzIwMjIwODI1MDUxODI3LjI0NjY5OC0xLWphcmtrb0BrZXJuZWwub3JnL1QvI3UNCj4g
Rml4ZXM6IDUxYWIzMGViMmFkNCAoIng4Ni9zZ3g6IFJlcGxhY2Ugc2VjdGlvbi0+aW5pdF9sYXVu
ZHJ5X2xpc3Qgd2l0aCBzZ3hfZGlydHlfcGFnZV9saXN0IikNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmfCoCMgdjUuMTMrDQo+IFJlcG9ydGVkLWJ5OiBQYXVsIE1lbnplbCA8cG1lbnplbEBt
b2xnZW4ubXBnLmRlPg0KPiBTaWduZWQtb2ZmLWJ5OiBKYXJra28gU2Fra2luZW4gPGphcmtrb0Br
ZXJuZWwub3JnPg0KDQooR2l2ZW4gdGhlIGlkZWEgb2YgbW92aW5nIHNneF9wYWdlX3JlY2xhaW1l
cl9pbml0KCkgdG8gdGhlIGVuZCBvZiBzZ3hfaW5pdCgpIGlzDQpjb25zaWRlcmVkIHRvbyBiaWcg
dG8gZml4IHRoaXMgYnVnOikNCg0KQWNrZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVs
LmNvbT4NCg0KLS0gDQpUaGFua3MsDQotS2FpDQoNCg0K

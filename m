Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78664F6BC6
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiDFUzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234008AbiDFUzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:55:32 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE041E747B;
        Wed,  6 Apr 2022 12:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649272438; x=1680808438;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hmChWSS47V4a0LW2pCM6AfL0ioInywaKnceFmTKCBIQ=;
  b=X6hX5ZKSNXcvFHpeO+VoUrRrGZxMK7pra+7WegS4QoUNalzs0ug0iP+j
   5C+e3Z/Fca1p0USO/qeE8w9jm3ftxtJktWrgVmesD/7Zmiv+xnnK2JWwE
   VVUWC+HAfdkcLxtoBf4lnNS3Gn7uKG3HlMB7o4gdBK1J3hzSPYgSEheiR
   9edwaDicVgODsI1W1pdXRe0XW7xTyd4UAH1R6gliqRazVFjkTQTsX3Air
   hMP/J+sptqSeKERuzp3Wgow6GscyvCzRITNqJJEK/kcpw45etPzDIOR9B
   pCa1FDd4h6bus3RJ1sDuV2/eMAR+x7KEwivgBJqWX4I2tbWBSNCz9hwz7
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="243270592"
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="243270592"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 12:13:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="609023479"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 06 Apr 2022 12:13:57 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 6 Apr 2022 12:13:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 6 Apr 2022 12:13:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 6 Apr 2022 12:13:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/2j1DQFkHD1+zHW1l8BRr8Y1rT/G8fglOGUl9zUwX8OG6LjvZbfHDZLI1vlkkiML4qaGwtjyVD0cVg4AfMvCXnYtxHYAMiUWu1AAb0T6AdSIRtye5NQQSrzywHUsZynHBEKuu/JzM3vs+aNME+Ecs8nEg2xx8Jn4roINJNsJDL4gPVOPKxZ+T4IYo3bheLZKkYblEBzmIEp19A4clrc/sWfiGVpfjZPwXSwjXM0RDwX1UjNQKzhmPWos1AlLUy056ogqGwQJam4qJ6h8xKV7gD7rquOr8yCoGq8QfQg29UuvOE3VajGyUhgdfruv9bwKr0bqJZoNhHZTa0ba62D3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmChWSS47V4a0LW2pCM6AfL0ioInywaKnceFmTKCBIQ=;
 b=e7qrgRWqQ4IIugATUFPxeVsFM/QEmiFxbQJlV13fRdjaxrzKAwrFUYl1AIKgfwwrRlAb+TKfFnywCExbAD/MNwe8AyukyGJB5ZBUhcNjsklc4rnayOcSosB1UAIC0qWMQX1xFRGjyZH+5dZHGYM1f7aD8h/sMGx2/DX3VkJTGr6OtECe8MGf6nsKhleUAopm5bX2XIgQv+72OIiMdormft0HfuLwuh25nGY2NJLW15uK5tE+QF6xEByfa31oWV/95PoongWw/WwiYEp/SHfIToulTTCz5QKuP8hoFKP9roYYgy/kEMhuP79X1N2pqCkDjwTRXsVRREQoSZyIw/TDmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by SA0PR11MB4654.namprd11.prod.outlook.com (2603:10b6:806:98::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Wed, 6 Apr
 2022 19:13:54 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b%7]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 19:13:54 +0000
From:   "Krishnan, Neelima" <neelima.krishnan@intel.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "antonio.gomez.iglesias@linux.intel.com" 
        <antonio.gomez.iglesias@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Poimboe, Josh" <jpoimboe@redhat.com>
Subject: RE: [PATCH v2 2/2] x86/tsx: Disable TSX development mode at boot
Thread-Topic: [PATCH v2 2/2] x86/tsx: Disable TSX development mode at boot
Thread-Index: AQHYNMqKOgkLislM80KYh4A57z5ulqzWqTmAgADa5QCAC+PPYA==
Date:   Wed, 6 Apr 2022 19:13:54 +0000
Message-ID: <CO1PR11MB476963E645081B2DE6FB91C88CE79@CO1PR11MB4769.namprd11.prod.outlook.com>
References: <cover.1646943780.git.pawan.kumar.gupta@linux.intel.com>
 <347bd844da3a333a9793c6687d4e4eb3b2419a3e.1646943780.git.pawan.kumar.gupta@linux.intel.com>
 <YkMyo2Jw8iYx9wAU@zn.tnic> <20220330052730.odzigmf4dkqkqfhk@guptapa-desk>
In-Reply-To: <20220330052730.odzigmf4dkqkqfhk@guptapa-desk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f68226e-d51b-4de1-bbb0-08da180197ab
x-ms-traffictypediagnostic: SA0PR11MB4654:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SA0PR11MB465418FB928A2D2E79FB15938CE79@SA0PR11MB4654.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UxC10mrZXb+T0d7f3ywgy5QwgSYDbsW86vHEf+mRdamslnhpAuSFruj+KCRxIzp2YZTPweiPrRTTu1Z60a8DvKsk4ID0Ra/qwZVDbeHfmgBvQIfWxWAjUItp8wYj4Yp/JeeCYv9Uvem8Kl8Kd7DTw5YBpWZEV3N/GoTXU5thBe5RJV/S44yYFR0FJXg65sxLawygNN2HFTjD3Im8aRNV5u5eT50YWHaMgMs2XT27kMS6eFzHsHz4LqGV+SYSZ5f2f2IX+SbCMvDvmBWy048SNziV5+v+OV6eyD0z1eUYQGc/6zMNxcHghXtEDDnmVsx5O+dAHOImcjIZkvorYCJ4UYAaLfjNhTcyCiNbqMAj+YDfAql6GWhdTKmi9EtCliKDTpPMNVH5Ul5LbHD+ufTcs68Eo30wj2X/y+JPSg1N4O5zLUj0fNw1N8z9f4FIiRLszW7icmeHN2O/ZGrQ8jCB0FdeDumz40wSuWR3SfKjBoJn3Uab57wSyl94QFwOuiP1SxG65oppc3N7gUpwmWWWJEj2m6OdYv2Rh1V5r/3o2G+FDHcPSHjKswRnPFnga6UBIMIAiHPmKFlnBUNuiAYcv4rJjXW0O252Z+8VKAJu1AuQhpDtlbpUZvKgGIoyMJHKMp5pAsQktPNNp5ygcExscWhgojYch+jrwKsA0ia8YxnbyR1lJnGGA02N0stZrXk7/JBAVKisFF0UT9ai6Bgc+PKwYm1zDWcLofVCbBg6jFsBW4K2sI5Nd+VoWX8wHZoDaZTemWUe2cU4VcaaknKfKn75gGaqlwrMCGeCSHSW1kKDmL7CVBoHW63HuORNjaUP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(82960400001)(38070700005)(83380400001)(26005)(186003)(122000001)(8936002)(5660300002)(7416002)(38100700002)(52536014)(6506007)(508600001)(66946007)(8676002)(55016003)(4326008)(64756008)(2906002)(66476007)(9686003)(7696005)(53546011)(316002)(66556008)(71200400001)(966005)(110136005)(66446008)(54906003)(76116006)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnBxSytVR3VjTHhHcFJYZW9kRnJucktQT290b3RLa2RGd3d2VHhmNlg2NDA1?=
 =?utf-8?B?YUVnWEt1bi9zSGVSUjlKZEh2RFU0YW16aGdiRGJ3L1VJeEswNFJObXlMQytj?=
 =?utf-8?B?bkcyb2kvYU5qQVEwMGU4aTVDWjY5ZDRpWHk4bzFLOXpDSUlJNnhSV2IwZ0Fx?=
 =?utf-8?B?WFNuTTN1M212VTU1UnJXYVdtemhGQXJQcitwUGNzR3RYTG9IeVNyTTVyMVR2?=
 =?utf-8?B?ejZFd0tyQ1JqZXhhS0dKbU9CMnQ4K0NFeTcvYjNUL2lUa0RIUzVIMkZvb1ox?=
 =?utf-8?B?eENEekNRcUQrK0d0Z2M2Z2dVS0pRUnZ5cXM1SXZTTlU1ZDVnbTByalhLZzRJ?=
 =?utf-8?B?N3ZWZ3F2N0tJUlhxUmhRdlZEMC9leWtsaTZ2eit1aXFoT2s5NForaG5LbE94?=
 =?utf-8?B?Z0huUDAwNVE3SVpKVUg1WU9KM1VCSTY1WnlQcDFDdVU0M2NFLzdWaHJBZDZ5?=
 =?utf-8?B?a2djTWFYYnduK2JpLy9nVUtaSVZoeEttV0E2dm5nUVIydm15c0V0cnp3YjRl?=
 =?utf-8?B?Z21mV3dwQVpMdFJ6aXorek9MN0FCSG5HUXhZUzZIWUtSUUx3SkFwUGZWNHRC?=
 =?utf-8?B?cTNrdXVXN3R4UEYvOTNPY0NLTVRzMmRaU3VvV1hmUUVuYnhkcVM1Q2lRKzcx?=
 =?utf-8?B?akhLL3pMK2tiNmZweUpGL0pUTzNiYWM4NmpSdkpnVWNGdDc4Y2FEckpvdW15?=
 =?utf-8?B?bFZHWHVYNStHTUlUUmF1OUJxNXM5N1NEQlpKNTVCZzJuWnFIeDhYa3prUmps?=
 =?utf-8?B?Mm5pbnJjMFM3eDNqTGZwQzhYVVd0Y0h2eHhlT2FKNFFKMEU3WlMxWFJtZk5J?=
 =?utf-8?B?dkdvUnJHMXZxdnZKamM4c1lBc3J1ZGw0UWJOMERkcDBCdDQwSU5xanZLTEV3?=
 =?utf-8?B?M2NTbUF0cWpmRlFDN3NobXlVcHBYREIrRzArN3hoZFBuQUc4VDBJU2V6WjR2?=
 =?utf-8?B?SExqRVg2UFpEYWczWDR5TGlCL09tT2NYV1NwL2VNRGw5WWFrOXlCR25pN1Zy?=
 =?utf-8?B?Q1pnY0ptanBVN3hKQ1kyekplSUF5NWIvMzJuZHJZYkpmNlVvOEI3bWZ5WFZL?=
 =?utf-8?B?K01lTldJZWNkRkNqOTFMZTAxRURZbWVHYU9SazhCNXZNT2ZMM003cmpPMWE3?=
 =?utf-8?B?OVBsWkRGTFBvYy9VdmJreHZja2svd1JjK3l3UFlabzlnQTA0bXJGTGp1SDI2?=
 =?utf-8?B?ancxVmpwQlRSR3JPNUhzNmxIZlJIaDlJUm5wLzJ4a0RpMHBEVDNKVStDL3d4?=
 =?utf-8?B?TmRHWlArWEhIVW9XZUMzWm9UeE5maSt4d3B4VFZLWFNpK1B5WVRTYzZ3ejNL?=
 =?utf-8?B?SUdKekJ0V29qMGU5RlcvNk9RUVZySUhwanhsbHZ0VjFROEtFblhmZnJqTjg3?=
 =?utf-8?B?OFNONXJnamFVTHFjeWhZMy9nR0Z3eE1hYjR3SytwZ0FOckRoREhEbjFWSG8y?=
 =?utf-8?B?WWRjTW45V2tPMmVPK2NrVUZMSnc1dkQ4NEFsbE1GQUJPbWFuR3p2NmtFb05I?=
 =?utf-8?B?V3YrTWp1OFRTd3JseEk4dHdiUnJuenZOODRlc2pqUFJIeHVSV2YvZ1NDbzg5?=
 =?utf-8?B?NDNBVm4zc1U2R0Z2aXRPOUJYY1ZpU3ZNS3NVOXpndUJYcEZST3lXcVczQ1hw?=
 =?utf-8?B?enIxa25iUUFoeFVnVmRiRitRUWJ4cWZlK3RBZ1IzQTdNUFFoMlR3bkJranI2?=
 =?utf-8?B?NlBOd3JmUlZQMGpqSDNpWGU1UFhIZTRuSnkzMC9mK0xBTFBqVjBCdGdmaHZh?=
 =?utf-8?B?ZFdObE8wNzhRd052TklvNnpaVlprZkpkYnJjWmcvUGZkaDdnL1lmT2w4RnFZ?=
 =?utf-8?B?dFd1d1RSaHYrbkFnUEtqZ2Qrb0lsb2pOZ0hIUTJRZFhGOGRYRm52QlVHeVpH?=
 =?utf-8?B?b21UWEFLUjNLRzgrcFRKRXJ1R2c0b3ZhWHBXLzNBRno1cUs3MEtzcHJVaXFq?=
 =?utf-8?B?SzF2bVBRdDdYS09GTmJlSmJDUHBJK1FEZnkrSTFXa3AybkNDa0g4R0djY1BS?=
 =?utf-8?B?eUtXQ1JZSy9URUNCUTVQZktvaFBBSk90WnJyZ1czN0JraGM1WDRWL1hVeEZ0?=
 =?utf-8?B?MXF3L2VWMDEwU1p6ZVFVeEhJdDBQUXRHNG5wNFFoOTZvbU5zOTZMOGpyalZP?=
 =?utf-8?B?R05PQUtWcm1IQWNycEdCL05IMjZZcEljSlh4Qzl1emR1cjZjSkx5N3NwdkJ0?=
 =?utf-8?B?K0lZb0NabmxvaVYwbEFIS1VZNEgrckJpaW5YcmRXTUE4NUpXY2ZJMGlwdGZ5?=
 =?utf-8?B?ZDNOc2J6a3I0VU4xQksrL3JFMDNlMnhsNU5BUS9uYU5jYm02anQwS1pNOE4v?=
 =?utf-8?B?VFBlMWxyaXlWbmN0S2x0STBwL0lacDIrUHQ3dGpBZVVaVjlkQTdxQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f68226e-d51b-4de1-bbb0-08da180197ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 19:13:54.4213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fNav3IE2OmaCCU09MTQQDETp611ipaJXhXIhIEvm337dv3kgEbEs3I4jBO9mrUW1XxJlUHcEb34eg7aDhFC/GmdeuH8GlGBBzJ4U9gTzH+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4654
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBQYXdhbiBHdXB0YSA8cGF3YW4u
a3VtYXIuZ3VwdGFAbGludXguaW50ZWwuY29tPiANClNlbnQ6IFR1ZXNkYXksIE1hcmNoIDI5LCAy
MDIyIDEwOjI4IFBNDQpUbzogQm9yaXNsYXYgUGV0a292IDxicEBhbGllbjguZGU+DQpDYzogVGhv
bWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+OyBJbmdvIE1vbG5hciA8bWluZ29AcmVk
aGF0LmNvbT47IERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBsaW51eC5pbnRlbC5jb20+OyB4ODZA
a2VybmVsLm9yZzsgSC4gUGV0ZXIgQW52aW4gPGhwYUB6eXRvci5jb20+OyBBbmRpIEtsZWVuIDxh
a0BsaW51eC5pbnRlbC5jb20+OyBMdWNrLCBUb255IDx0b255Lmx1Y2tAaW50ZWwuY29tPjsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgYW50b25pby5nb21lei5pZ2xlc2lhc0BsaW51eC5p
bnRlbC5jb207IEtyaXNobmFuLCBOZWVsaW1hIDxuZWVsaW1hLmtyaXNobmFuQGludGVsLmNvbT47
IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IENvb3BlciwgQW5kcmV3IDxhbmRyZXcuY29vcGVyM0Bj
aXRyaXguY29tPjsgUG9pbWJvZSwgSm9zaCA8anBvaW1ib2VAcmVkaGF0LmNvbT4NClN1YmplY3Q6
IFJlOiBbUEFUQ0ggdjIgMi8yXSB4ODYvdHN4OiBEaXNhYmxlIFRTWCBkZXZlbG9wbWVudCBtb2Rl
IGF0IGJvb3QNCg0KT24gVHVlLCBNYXIgMjksIDIwMjIgYXQgMDY6MjQ6MDNQTSArMDIwMCwgQm9y
aXNsYXYgUGV0a292IHdyb3RlOg0KPk9uIFRodSwgTWFyIDEwLCAyMDIyIGF0IDAyOjAyOjA5UE0g
LTA4MDAsIFBhd2FuIEd1cHRhIHdyb3RlOg0KPj4gQSBtaWNyb2NvZGUgdXBkYXRlIG9uIHNvbWUg
SW50ZWwgcHJvY2Vzc29ycyBjYXVzZXMgYWxsIFRTWCANCj4+IHRyYW5zYWN0aW9ucyB0byBhbHdh
eXMgYWJvcnQgYnkgZGVmYXVsdCBbKl0uIE1pY3JvY29kZSBhbHNvIGFkZGVkIA0KPj4gZnVuY3Rp
b25hbGl0eSB0byByZS1lbmFibGUgVFNYIGZvciBkZXZlbG9wbWVudCBwdXJwb3NlLiBXaXRoIHRo
aXMgDQo+PiBtaWNyb2NvZGUgbG9hZGVkLCBpZiB0c3g9b24gd2FzIHBhc3NlZCBvbiB0aGUgY21k
bGluZSwgYW5kIFRTWCANCj4+IGRldmVsb3BtZW50IG1vZGUgd2FzIGFscmVhZHkgZW5hYmxlZCBi
ZWZvcmUgdGhlIGtlcm5lbCBib290LCBpdCBtYXkgDQo+PiBtYWtlIHRoZSBzeXN0ZW0gdnVsbmVy
YWJsZSB0byBUU1ggQXN5bmNocm9ub3VzIEFib3J0IChUQUEpLg0KPj4NCj4+IFRvIGJlIG9uIHNh
ZmVyIHNpZGUsIHVuY29uZGl0aW9uYWxseSBkaXNhYmxlIFRTWCBkZXZlbG9wbWVudCBtb2RlIGF0
IA0KPj4gYm9vdC4gSWYgbmVlZGVkLCBhIHVzZXIgY2FuIGVuYWJsZSBpdCB1c2luZyBtc3ItdG9v
bHMuDQo+Pg0KPj4gWypdIEludGVsIFRyYW5zYWN0aW9uYWwgU3luY2hyb25pemF0aW9uIEV4dGVu
c2lvbiAoSW50ZWwgVFNYKSBEaXNhYmxlIFVwZGF0ZSBmb3IgU2VsZWN0ZWQgUHJvY2Vzc29ycw0K
Pj4gICAgIGh0dHBzOi8vY2RyZHYyLmludGVsLmNvbS92MS9kbC9nZXRDb250ZW50LzY0MzU1Nw0K
Pj4NCj4+IFN1Z2dlc3RlZC1ieTogQW5kcmV3IENvb3BlciA8YW5kcmV3LmNvb3BlcjNAY2l0cml4
LmNvbT4NCj4+IFN1Z2dlc3RlZC1ieTogQm9yaXNsYXYgUGV0a292IDxicEBhbGllbjguZGU+DQo+
PiBTaWduZWQtb2ZmLWJ5OiBQYXdhbiBHdXB0YSA8cGF3YW4ua3VtYXIuZ3VwdGFAbGludXguaW50
ZWwuY29tPg0KPj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPj4gLS0tDQo+PiAgYXJj
aC94ODYvaW5jbHVkZS9hc20vbXNyLWluZGV4LmggICAgICAgfCAgNCArLS0NCj4+ICBhcmNoL3g4
Ni9rZXJuZWwvY3B1L2NwdS5oICAgICAgICAgICAgICB8ICAxICsNCj4+ICBhcmNoL3g4Ni9rZXJu
ZWwvY3B1L2ludGVsLmMgICAgICAgICAgICB8ICA0ICsrKw0KPj4gIGFyY2gveDg2L2tlcm5lbC9j
cHUvdHN4LmMgICAgICAgICAgICAgIHwgMzQgKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+
ICB0b29scy9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tc3ItaW5kZXguaCB8ICA0ICstLQ0KPj4gIDUg
ZmlsZXMgY2hhbmdlZCwgNDMgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4NCj5Eb2Vz
IHRoaXMgYSBsb3QgbW9yZSBlbmNhcHN1bGF0ZWQgdmVyc2lvbiB3b3JrIHRvbz8NCg0KPk5lZWxp
bWEgaXMgdGVzdGluZyB0aGlzIHBhdGNoLCBzaGUgd2lsbCBzaGFyZSB0aGUgcmVzdWx0cyB0b21v
cnJvdy4NCg0KRm9sbG93aW5nIHVwIG9uIHRoaXMgZW1haWwgdGhyZWFkLCBJIGRpZCBzb21lIGJh
c2ljIGZ1bmN0aW9uYWwgdmFsaWRhdGlvbiBvZiB0aGUgcGF0Y2hbMV0uIA0KSW5pdGlhbGx5IEkg
cmFuIGludG8gdGhlIGJ1ZyB3aGVyZSB0aGUgbWl0aWdhdGlvbiB3YXMgZ2V0dGluZyBkaXNhYmxl
ZCBpbiBvbmUgQ1BVIGFmdGVyIGEgc3VzcGVuZC9yZXN1bWUgWzJdLiANCkJ1dCBhZnRlciBhcHBs
eWluZyB0aGUgcGF0Y2ggWzFdIG9uIGxhdGVzdCB1cHN0cmVhbSwgd2l0aCB0aGUgZml4IGZvciBy
ZXN0b3Jpbmcgc3BlY3VsYXRpb24gcmVsYXRlZCBNU1JzIGR1cmluZyBzMyByZXN1bWUgWzJdLCBt
eSB0ZXN0cyBhcmUgcGFzc2luZy4gDQoNClF1aWNrIHN1bW1hcnkgb2YgdGVzdGNhc2VzIGV4ZWN1
dGVkOg0KVGVzdGNhc2UgMTogIFZlcmlmeSBSVE1fQUxMT1cgd2FzIGdldHRpbmcgcmVzZXQgYWZ0
ZXIga2V4ZWMgcmVib290DQpUZXN0Y2FzZTI6IFZlcmlmeSBUU1hfQ1RSTF9NU1IgaXMgcmVzdG9y
ZWQgYWZ0ZXIgc3lzdGVtIGdvZXMgdG8gUzMgc3VzcGVuZCBzdGF0ZQ0KDQpbMV0gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvbGttbC9Za015bzJKdzhpWXg5d0FVQHpuLnRuaWMvDQpbMl0gaHR0cHM6
Ly9naXRodWIuY29tL3RvcnZhbGRzL2xpbnV4L2NvbW1pdC9lMmExMjU2YjE3YjE2ZjliOWFkZjFi
NmZlYTU2ODE5ZTdiNjhlNDYzDQoNClRoYW5rcw0KTmVlbGltYQ0K

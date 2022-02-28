Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9137E4C7885
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 20:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiB1TOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 14:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiB1TOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 14:14:39 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7F4D5DE6
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 11:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646075639; x=1677611639;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Dts+B0dKHoNBv1RxlEn/YSyJkLmgDn/fn89iEW41xMw=;
  b=QUtQnsI3RZIHCxbmEPWVy6urHScosK76+Sm7TbVfUy+9OBQ+IE8cr/3a
   OJF8nK6RtXX2fJv2NBMYH+Ip5sRh+OMwjwLdlbtH4lbujqrqRYeclwmNP
   YDs1KSdCqRNYtYD1MYYCVpXYE3DYgpx/4GfWEdUwYzhdLbT+WIYqorOJe
   dziFmYzfTkm1rd6+HNrai+pjuIXiwdXaFbx04yuvu33oHKlSkYZP3Ss+E
   fUlpy/TVaKCYyN+UxRpI8UIoPh23EZlpXIycEOBR0OMtNoYOyqOcXoXZ2
   6HiCsB0DGPdVeqGtVDbA0v4VZ3rqRtLNLybK8m9guSHZ55Cy55hUp01rf
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="313683482"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="313683482"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 11:13:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="593329221"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 28 Feb 2022 11:13:38 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 11:13:37 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Mon, 28 Feb 2022 11:13:37 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 28 Feb 2022 11:13:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTDtw5r6/kaNyboAZQJ8Hv5Ft2oQjvkN+33QC/UGRn8CQY/pE1xBFaX55LGIhaha1NCs3zpdK2J3Wh38ZaIEyFyDe0U6567/8vpaHrD/rQe2SE8WLWYA+rgf/u947kSkbE8ofmZfi3kg7tK7zXg/DJ9rmEo/em7ErAmgfJWr9lQ6LGQhyFXXUoT8D8kBZzu28d5txN3Q9aOhpOG8+5cCZVG/NkL2cH2GPCbkd30HdOy1uOCAq2TbF9fIK7WPmFfx17iRH11EhRt/38GHcxjbs8zEoa7y7XyzG3QG3PpUBCkb/xJaOcIBicW6oCcbYutPCeBXkz9XgSioYUUb911l9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrgx4QQRtBYCJkS/aWy0kbD5G3dzLJIkChuzi+BKeDk=;
 b=mhR1V9TpMTOKTVV8z8tkvNgtkWbKGLuRsz1geDOFtTgDiM2I7qQ7nCbv23/Q2VM0TdshbOX6a72zMqmwM06rvkMQiaUMamwEvebiV+L1hZJ3bLvwpEYo26p7H0VHaDOEKYSPROnaAX57BfwNcbrzSKYWiSUNKCcFuVgooKaHrm+XcS9or12iAXz7u+SA8u5kdwb4fWw4qtBpYBte03/vH7M4WxEe3HhyE3uP4OuWMCSGY1yns3P55rR5Q5aAqH0hOaRK5BVhpNbuN1ZW+pq2gOlYAenMAopDcUNwJREbXvh2LoHA7Oxt4DTF23n5Tn2QnDCzYL6K0RP9ZVe+KOk5Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB5032.namprd11.prod.outlook.com (2603:10b6:510:3a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Mon, 28 Feb
 2022 19:13:36 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd9e:6244:4757:615a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd9e:6244:4757:615a%8]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:13:36 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Brett Creeley <brett.creeley@intel.com>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH 1/2] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Thread-Topic: [PATCH 1/2] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Thread-Index: AQHYKoV1oS8OxtgVzUaACL1TTVzKm6yo0oAAgAADzICAAIMWYA==
Date:   Mon, 28 Feb 2022 19:13:36 +0000
Message-ID: <CO1PR11MB5089F3BE00BEA394352CFAE4D6019@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220225202101.4077712-1-jacob.e.keller@intel.com>
 <YhytnJGxStO0Gai9@kroah.com> <Yhywy/LYW38Aavxt@kroah.com>
In-Reply-To: <Yhywy/LYW38Aavxt@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b244bad6-7283-4ce9-cda5-08d9faee6b7e
x-ms-traffictypediagnostic: PH0PR11MB5032:EE_
x-microsoft-antispam-prvs: <PH0PR11MB5032238CD456A32DE451C843D6019@PH0PR11MB5032.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: acmqccR5Ksb3dZ7Ocgi9hW4+ubcrgokf3GmD8ttWJ4pPmyIKzep3aPVUFoiYAk4lhIYslvgm+te+KdCabvu0aybadIy5+T4nHMy+Qem5OXHMslNJI35ytVqPk5BTMGupPvMxfn8UNUywT5v3n/Yxa1yUiJvhAU/AVoAD8Kc9J7YaLMqlmQzVZWj9WyCxWfI8sFkpK7Qtp/imgyoCBhPb0EeBkT05rBB7x3Os5hFU2aDZ/aSrJHF1x/lajJKIZGSXuceVs2GD89q/ZMVa9/yD2yBKyupHDj0LElg0vSBxYH9JEtu65jNyEU+ygp8g+caqLncUoChr9QT44iWF8+pj7H03znzlH/LF69C9lriZP46yaYBKVEsvckcZkyWhfb/hQ/xPzlVNIazAQs1aBJB3WIAEJbVzH4viQKfje2Ix3I3OCVx+lO1b8Wr5MDfHEeO6uoWAyrRNYIVnG3rRub130UUk4aUDM+8YEKV26bWLJ4XHQiYSxTi/X2m1DF0rLVM9EdzASE1xmjsiRmIwQyZ2NRt2TDszFd4CbGbKiaIKhSweLzw37i0GnRq8QetdvvX+BuMchfIWfPO/MmPAh2ERqXvkO/iZ3yT9c6GouxDovtw6keCMkaHuccn3xLfBiCL5mUvL5VRWfaSOJX15RwA7ZNTCMONRO3i3urEBuN79/ZFB2evVzglQDRFKmaUd5potnoGoUyP56MaY/h1/7GlGQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(6916009)(53546011)(6506007)(54906003)(26005)(316002)(52536014)(71200400001)(86362001)(8936002)(83380400001)(5660300002)(76116006)(66446008)(7696005)(8676002)(66946007)(4326008)(66556008)(66476007)(33656002)(38100700002)(64756008)(122000001)(9686003)(107886003)(55016003)(82960400001)(508600001)(38070700005)(4744005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sW0HzT4+jyTyRlJOgMz0HTUzcG0nj+PYQ4lw2DAJIIkrxnwXfJySMNI3kQX8?=
 =?us-ascii?Q?blPunrWbkrdcBnrQqWEXVINyUs+R7eWLqdJr1A/T14fvbBhC022faOAfDibx?=
 =?us-ascii?Q?oxtHWK7eMQC3Y3hEmcoc6Rblzm7t5CUYU0RT2Bfhe9TOarw4hRNsMXMApC3G?=
 =?us-ascii?Q?+UzYLk2aNLKbDEfurVmQrPMpJvXw79A0qTztTAiiL3ukwq8YBBHfK0glUHyh?=
 =?us-ascii?Q?yzhFXHh/Kdnjj8oRGYjV/SnGrPRdfR2jA/EVClMDjCnHikmFouzeXnkDKP4p?=
 =?us-ascii?Q?+7TkAtKhLPnRUYaCLSMGK7ojT8E+JZusl+6X6t3yNouT8/O72jEeNAf8tcCh?=
 =?us-ascii?Q?I0CE/cy5N3BoqTty5CBxFcdysFO6m/hAgFVpgD3aHg0ouOwmbX5OrxMbFkGT?=
 =?us-ascii?Q?xIy1UGzvfM838s2aO0ogSh6/6cXYXh0uA8wa/BlB2qxvW2KyoCIUDEbc3PX6?=
 =?us-ascii?Q?SvAxAsRU968K2sUzPUwbMeeqQqAOjOFu8eepGxehFOywZ1Hv5KPyNd4U+mUT?=
 =?us-ascii?Q?DzeDrVcPxD2a0v/pGrZrfwIEa2mTNcgLul3l1DrkecEVJzK7j5wNVX6hgUm2?=
 =?us-ascii?Q?NoPQQTe3FNiZIc8fFBU8+y3N5uzhzHJH0gqTqb7yg2Wgnj82ZIuu2y0fjt3Y?=
 =?us-ascii?Q?wYBkIgL4TZyRTME0ETS6lms/3Z2bMQ7P1QmHt5LU1T1Uk7L25TbTfZ4wLx2m?=
 =?us-ascii?Q?A5/nbWYlFyXsuFI25HdxFh4R3fM3rS+r5RA8KJWREEQYFms2FvHG/rmVR/Xe?=
 =?us-ascii?Q?rr1EoYuS8+o8SfdwP+3k2ujKDQxB/RlEPIRwUI3P6h5qfBb2e4R1ZmcAloTR?=
 =?us-ascii?Q?MqEOIT7e+EHkICqxMH4O2RMW0WxG29NFqnvC9SD8VKyxUgpea2JTbcE8J/7V?=
 =?us-ascii?Q?DBZCFEIW68F/SqiMFGTN9wbJnivW0QZX3E53UUtZ+GjZHasUmWJmVlc5a5h9?=
 =?us-ascii?Q?QKNZ0fR42Fg7Y6mUew+XhhBIC082RlkervInETmxcV4wtDxFr4w2/aYL7ToW?=
 =?us-ascii?Q?n8eSpByY/FMYp9J5EKVC0H4duhk6FC686grx0oyoaBWTh5dhpeeBWVM4eQOM?=
 =?us-ascii?Q?rr6bRijv62CTYQ+NECzFUgqhMvPHolqtuJ4VLln12dYkVTCLp5NfDOY4JMC7?=
 =?us-ascii?Q?bbwSa3EVnwZzAedi3HOdESX1NlzgcEQllM+f2LIhq/QRliWYSkwaZyOPtc4S?=
 =?us-ascii?Q?msGtJi4kyhgrd5sNEaF5tyn7qWpcUPFLMUg4ZeAZqOjSKJ+91r5U4Zhw2f4R?=
 =?us-ascii?Q?FdeiiLnzjtTBSU7DJ1AB4v4BkbWjHw9V+V6y+cNcy4rfpQZVK1Z1kmt0hrY9?=
 =?us-ascii?Q?6J2yZeW3yg9h5KKXTg9fhIzi0oeqDkkgNlNaLdYxc0CC1iwKSmZt28SyZUTs?=
 =?us-ascii?Q?wmxOqsiXhr85s6p8XsTQc/QoH9g0zj3+MW01w0b8/rAgXgnjJrSNj1R05Lfc?=
 =?us-ascii?Q?/HqrzUjymKaaMEaWmVpmxJh0Ws+x6+fhTRvVrhF4rhr/YbnD7oExspUnT8KX?=
 =?us-ascii?Q?E9d3O6CRUhfzhNxJsZbEqJukPpfgKNHB1ZI4mzsvMFm+x7C7cGwJxeGTdZYL?=
 =?us-ascii?Q?so9I+vZQFzEdO0YqEwlmaWEUm2snyhZL10CCEE+xGZK64qh9rxRUQQTkasB1?=
 =?us-ascii?Q?0zcD+z1wadRjbGUR8RZGNMeAD5Q2DI6G20X3fR/mPLjCoSLnxLtp+7Igca6T?=
 =?us-ascii?Q?BeNkZw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b244bad6-7283-4ce9-cda5-08d9faee6b7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2022 19:13:36.1956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YoaWhDAIxW/smNjqRsdoIDpgxpsFEZ/1Evpcw207wkU9OQQUQ0HvQvPm6s4fptyOz5t8PdlZmefuTLKdFgy27dPk5rJPMyPV7pQKqw6AILQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5032
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Monday, February 28, 2022 3:24 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: stable@vger.kernel.org; Brett Creeley <brett.creeley@intel.com>; Jank=
owski,
> Konrad0 <konrad0.jankowski@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Subject: Re: [PATCH 1/2] ice: Fix race conditions between virtchnl handli=
ng and VF
> ndo ops
>=20
> On Mon, Feb 28, 2022 at 12:10:20PM +0100, Greg KH wrote:
> > On Fri, Feb 25, 2022 at 12:21:00PM -0800, Jacob Keller wrote:
> > > From: Brett Creeley <brett.creeley@intel.com>
> > >
> > > commit e6ba5273d4ede03d075d7a116b8edad1f6115f4d upstream.
> > >
> > > [I had to fix the cherry-pick manually as the patch added a line arou=
nd
> > > some context that was missing.]
> >
> > What stable tree(s) is this for?$
>=20
> Looks like it applied only to 5.15.y.  Can you also provide backports
> for the other older kernels that these are needed for?
>=20

Yes, let me take a closer look at the older ones.

> thanks,
>=20
> greg k-h
